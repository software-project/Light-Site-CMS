Ext.onReady(function(){
    Ext.QuickTips.init();

    var mailIsDirty = new Boolean(false);
    var rolesAreDirty = new Boolean(false);

    function setActivateButton(button,active,record){
        if (active == true){
            button.setText("Deaktywuj");
            button.setHandler(function() {
                Ext.Ajax.request({
                    url: '/admin_panel/deactivate',
                    method: 'post',
                    params: {
                        user_id: record.get(combo.valueField),
                        authenticity_token: token
                    },
                    success: function (){
                        Ext.Msg.alert('OK', 'Deaktywowano użytkownika.');
                        setActivateButton(button,false,record);
                    },
                    failure: function ( result, request) {
                        Ext.Msg.alert('Błąd', 'Nie można deaktywować użytkownika.');
                    }
                })
            });
        }
        else
        {
            button.setText("Aktywuj");
            button.setHandler(function() {
                Ext.Ajax.request({
                    url: '/admin_panel/activate',
                    method: 'post',
                    params: {
                        user_id: record.get(combo.valueField),
                        authenticity_token: token
                    },
                    success: function (){
                        Ext.Msg.alert('OK', 'Aktywowano użytkownika.');
                        setActivateButton(button,true,record);
                    }
                })
            });
        }
    };

    //--------------------------------------------------------
    //  GRIDS
    //--------------------------------------------------------
    var emptyData = [];

    var emptyStore = new Ext.data.ArrayStore({
        fields: [
            {
                name: 'name'
            },
        ]
    });
    emptyStore.loadData(emptyData);

    var userRolesGrid= new Ext.grid.GridPanel({
        title:'Role użytkownika',
        ddGroup    : 'allRolesGridDDGroup',
        store: emptyStore,
        columns: [{
                id:'name',
                header: 'Roles',
                width: 1,
                sortable: false,
                dataIndex: 'name'
            }],
        stripeRows: true,
        autoExpandColumn : 'name',
        hideHeaders : true,
        enableHdMenu : false,
        border: true,
        enableDragDrop   : true,
        disabled :true,
        selModel :new Ext.grid.RowSelectionModel({
            singleSelect:true,
            listeners: {
                rowselect: function(sl, ri, r){
                    allRolesGrid.getSelectionModel().clearSelections();
                    Ext.getCmp('role-remove-button').enable();
                }
            }
        })
    });

    var allRolesGrid= new Ext.grid.GridPanel({
        ddGroup    : 'userRolesGridDDGroup',
        title:'Role',
        store: emptyStore,
        columns: [{
                id:'name',
                header: 'Roles',
                width: 1,
                sortable: false,
                dataIndex: 'name'
            }],
        stripeRows: true,
        autoExpandColumn : 'name',
        hideHeaders : true,
        enableDragDrop   : true,
        enableHdMenu : false,
        border: true,
        selModel :new Ext.grid.RowSelectionModel({
            singleSelect:true,
            listeners: {
                rowselect: function(sl, ri, r){
                    userRolesGrid.getSelectionModel().clearSelections();
                    Ext.getCmp('role-remove-button').enable();
                }
            }
        })
    });

    var users = new Ext.data.Store({
        proxy :new Ext.data.HttpProxy({
            url: '/users',
            method:'get'
        }),
        mode:'local',
        autoLoad: true,
        reader: new Ext.data.JsonReader({
            root:'users',
            fields: [{
                    name: 'id'
                },{
                    name: 'name'
                }]

        })
    });

    var userRolesGridDropTargetEl;
    var userRolesGridDropTarget;
    var allRolesGridDropTargetEl;
    var destGridDropTarget;

    //--------------------------------------------------------
    //  EOGRIDS
    //--------------------------------------------------------

    var userBar = new Ext.ButtonGroup({
        height:35,
        border: false,
        frame: false,
        minButtonWidth: 100,
        items:[
            {
                id      : 'user-activate-button',
                text    : 'Deaktywuj',
                disabled: true,
                handler : function() {}
            },{
                text    : 'Usuń',
                id : 'user-remove-button',
                disabled: true,
                handler : function() {
                    //refresh source grid
                    //firstGridStore.loadData(myData);
                    Ext.Msg.show({
                        title:'Usunąć?',
                        msg: 'Czy na pewno usunąć użytkownika? Operacja jest nieodwracalna!',
                        buttons: Ext.Msg.YESNO,
                        fn: function (btn, text){
                            if (btn == "yes")
                            {
                                Ext.Ajax.request({
                                    url: '/admin_panel/destroy_user',
                                    method: 'post',
                                    params: {
                                        user_id: Ext.getCmp('combo').getValue(),
                                        authenticity_token: token
                                    },
                                    success: function (){
                                        location.reload(true);
                                    },
                                    failure: function ( result, request) {
                                        Ext.Msg.alert('Błąd', 'Nie można usunąć użytkownika.');
                                    }
                                });
                            }
                        }
                    });
                }
            },{
                text    : 'Zmień hasło',
                disabled: true,
                id      : 'user-change-password',
                handler : function() {
                    var win = new Ext.Window({
                        layout:'fit',
                        resizable : false,
                        width:400,
                        height:180,
                        closeAction:'hide',
                        plain: true,
                        title : 'Zmiana hasła',

                        items: {
                            id: 'user-password-change-form',
                            xtype: 'form',
                            labelWidth: 100, // label settings here cascade unless overridden
                            url:'/admin_panel/change_password',
                            frame:true,
                            border:false,
                            bodyStyle:'padding:5px 5px 0',
                            width: 380,
                            defaults: {
                                width:230
                            },
                            defaultType: 'textfield',

                            items: [{
                                    inputType :'password',
                                    fieldLabel: 'Hasło',
                                    name: 'password',
                                    allowBlank:false
                                },{
                                    inputType :'password',
                                    fieldLabel: 'Potwierdź hasło',
                                    name: 'password_confirmation'
                                },{
                                    xtype: 'hidden',
                                    name: 'user_id',
                                    value : Ext.getCmp('combo').value
                                },{
                                    xtype: 'hidden',
                                    name: 'authenticity_token',
                                    value : token
                                }
                            ],

                            buttons: [{
                                    text: 'Zapisz',
                                    handler : function (){
                                        Ext.getCmp('user-password-change-form').getForm().submit({
                                            success: function(form, action) {
                                                Ext.Msg.alert('OK', 'Hasło zostało zmienione');
                                                win.destroy();
                                            },
                                            failure: function(form, action) {
                                                Ext.Msg.alert('Błąd', action.result.msg);
                                            }
                                        });

                                    }

                                },{
                                    text: 'Anuluj',
                                    handler : function (){
                                        win.destroy();
                                    }
                                }]
                        }
                    }).show();
                }
            }

        ]
    });

    var blogBar = new Ext.ButtonGroup({
        height:35,
        minButtonWidth: 100,
        frame: false,
        border: 'false',
        buttonAlign : 'right',
        items:[
            {
                text    : 'Zapisz',
                id : 'blog-save',
                disabled: true,
                handler : function() {
                    var blogObject = {
                        'user_id' : Ext.getCmp('comboBlog').getValue(),
                        'title' : Ext.getCmp('blog-title').getValue(),
                        'description' : Ext.getCmp('blog-description').getValue()
                    };
                    Ext.Ajax.request({
                        url: '/admin_panel/blogs',
                        method: 'post',
                        params: {
                            authenticity_token: token,
                            blog: Ext.encode(blogObject)
                        },
                        success: function ( result, request)
                        {
                            Ext.getCmp('blog-save').disable();
                            Ext.Msg.alert('OK', 'Zmiany zostały zapisane');
                        },
                        failure: function ( result, request) {
                            Ext.Msg.alert('Błąd', 'Nie udało się zapisać zmian');
                        }
                    });
                }
            },{
                text    : 'Przejdź do bloga',
                disabled: true,
                id      : 'blog-button',
                handler : function() {
                }
            }

        ]
    });
    
    var userInfoPanel = new Ext.Panel({
        labelWidth: 75,
        frame:false,
        bodyStyle:'padding:5px 5px 0px 0px',
        width: 300,
        height:190,
        items: [
            {
                xtype:'fieldset',
                bbar: userBar,
                title: 'Informacje o użytkowniku',
                collapsible: false,
                height:180,
                defaults: {
                    width: 180,
                    readOnly : true,
                    disabled: true
                },
                defaultType: 'textfield',
                items :[{
                        id: 'user-info-login',
                        fieldLabel: 'Login',
                        value: ''
                    },{
                        fieldLabel: 'E-mail',
                        id: 'user-info-mail',
                        readOnly : false,
                        vtype: 	'email',
                        vtypeText:  'Wprowadzony adres e-mail nie jest poprawny',
                        enableKeyEvents : true,
                        listeners: {
                            keyup: function(textfield, event){
                                mailIsDirty = true;
                                if(textfield.isValid())
                                {
                                    Ext.getCmp('user-save-roles').enable();
                                }
                                else
                                {
                                    Ext.getCmp('user-save-roles').disable();
                                }
                            }
                        }
                    },{
                        fieldLabel: 'Utworzony',
                        id: 'user-info-created-at'
                    },{
                        fieldLabel: 'Blog',
                        id: 'user-info-blog'
                    }
                ]
            }]
    });

    var blogInfoPanel = new Ext.Panel({
        labelWidth: 75,
        frame:false,
        bodyStyle:'padding:5px 5px 0px 0px',
        width: 500,
        height:270,
        items: [
            {
                xtype:'fieldset',
                title: 'Informacje o blogu',
                collapsible: false,
                height:220,
                width: 490,
                defaults: {
                    width: 380,
                    disabled: true
                },
                defaultType: 'textfield',
                items :[{
                        id      : 'blog-checkbox',
                        fieldLabel    : 'Blog',
                        xtype   : 'checkbox',
                        disabled: true,
                        listeners: {
                            check: function(checkbox, checked) {
                                if(checked){
                                    Ext.Msg.show({
                                        title:'Nowy blog',
                                        msg: 'Stworzyć blog dla wskazanego użytownika?',
                                        buttons: Ext.Msg.YESNO,
                                        fn: function (btn, text){
                                            if (btn == "yes")
                                            {
                                                window.location = "/blog/new/"+Ext.getCmp('comboBlog').getRawValue();
                                            }
                                            else{
                                                var checkbox= Ext.getCmp('blog-checkbox');
                                                checkbox.suspendEvents();
                                                checkbox.setValue(false);
                                                checkbox.resumeEvents();
                                            }
                                        }
                                    });
                                }
                                else{
                                    Ext.Msg.show({
                                        title:'Usuń blog',
                                        msg: 'Usunąć blog dla wskazanego użytownika? Operacja jest nieodwracalna!',
                                        buttons: Ext.Msg.YESNO,
                                        fn: function (btn, text){
                                            if (btn == "yes")
                                            {
                                                window.location = "/blog/new/"+Ext.getCmp('comboBlog').getRawValue();
                                            }
                                            else{
                                                var checkbox= Ext.getCmp('blog-checkbox');
                                                checkbox.suspendEvents();
                                                checkbox.setValue(true);
                                                checkbox.resumeEvents();
                                            }
                                        }
                                    });
                                }
                            }
                        }
                    },{
                        id: 'blog-title',
                        fieldLabel: 'Tytuł',
                        maxLength: 20,
                        value: '',
                        enableKeyEvents : true,
                        listeners: {
                            keyup: blogListener
                        }
                    },{
                        xtype: 'textarea',
                        fieldLabel: 'Opis',
                        height:90,
                        preventScrollbars : true,
                        id: 'blog-description',
                        enableKeyEvents : true,
                        listeners: {
                            keyup: blogListener
                        }
                    },{
                        frame: false,
                        height: 40,
                        width: 320,
                        xtype: 'panel',
                        layout: 'vbox',
                        layoutConfig:{
                            align:'center',
                            pack: 'end'
                        },
                        disabled: false,
                        items: [blogBar]
                    }
                ]
            }]
    });

    function blogListener(field, event){
        if(field.isValid())
        {
            Ext.getCmp('blog-save').enable();
        }
        else
        {
            Ext.getCmp('blog-save').disable();
        }

    }
    var combo = new Ext.form.ComboBox({
        id: 'combo',
        name:'User',
        store:users,
        triggerAction: 'all',
        displayField:'name',
        valueField: 'id',
        selectOnFocus: true,
        emptyText: 'Wybierz użytkownika',
        mode: 'local',
        enableKeyEvents:true,
        forceSelection: 'true',
        hiddenName : 'userId',
        listeners: {
            select: function(combo, record, index){
                Ext.Ajax.request({
                    url: '/admin_panel/users',
                    method: 'post',
                    params: {
                        user: record.get(combo.valueField),
                        authenticity_token: token
                    },
                    success: function (response){

                        Ext.getCmp('user-save-roles').disable();

                        var role = new Ext.data.Record.create([
                            {
                                name: 'id'
                            },

                            {
                                name: 'name',
                                type: 'string'
                            }
                        ]);

                        var dataReader = new Ext.data.JsonReader({
                            root:'user_roles'
                        }, role);
                        var store = new Ext.data.Store({
                            reader: dataReader
                        });
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        store.loadData(jsonData);

                        var dataReader1 = new Ext.data.JsonReader({
                            root:'all_roles'
                        }, role);
                        var store1 = new Ext.data.Store({
                            reader: dataReader1
                        });
                        store1.loadData(jsonData);


                        userRolesGrid.enable();
                        userRolesGrid.reconfigure(store, new Ext.grid.ColumnModel([{
                                id:'name',
                                header: 'Roles',
                                width: 1,
                                sortable: false,
                                dataIndex: 'name'
                            }]));
                        allRolesGrid.reconfigure(store1, new Ext.grid.ColumnModel([{
                                id:'name',
                                header: 'Roles',
                                width: 1,
                                sortable: false,
                                dataIndex: 'name'
                            }]));
                        allRolesGrid.enable();

                        userRolesGridDropTargetEl =  userRolesGrid.getView().el.dom.childNodes[0].childNodes[1];
                        userRolesGridDropTarget = new Ext.dd.DropTarget(userRolesGridDropTargetEl, {
                            ddGroup    : 'userRolesGridDDGroup',
                            copy       : true,
                            notifyDrop : function(ddSource, e, data){

                                // Generic function to add records.
                                function addRow(record, index, allItems) {

                                    // Search for duplicates
                                    var foundItem = store.findExact('name', record.data.name);
                                    // if not found
                                    if (foundItem  == -1) {
                                        store.add(record);

                                        // Call a sort dynamically
                                        store.sort('name', 'ASC');

                                        //Remove Record from the source
                                        ddSource.grid.store.remove(record);
                                    }
                                }

                                // Loop through the selections
                                Ext.getCmp('role-remove-button').disable();
                                Ext.getCmp('user-save-roles').enable(),
                                rolesAreDirty = true;
                                Ext.each(ddSource.dragData.selections ,addRow);
                                return(true);
                            }
                        });


                        // This will make sure we only drop to the view container
                        allRolesGridDropTargetEl = allRolesGrid.getView().el.dom.childNodes[0].childNodes[1]

                        destGridDropTarget = new Ext.dd.DropTarget(allRolesGridDropTargetEl, {
                            ddGroup    : 'allRolesGridDDGroup',
                            copy       : false,
                            notifyDrop : function(ddSource, e, data){

                                // Generic function to add records.
                                function addRow(record, index, allItems) {

                                    // Search for duplicates
                                    var foundItem = store1.findExact('name', record.data.name);
                                    // if not found
                                    if (foundItem  == -1) {
                                        store1.add(record);
                                        // Call a sort dynamically
                                        store1.sort('name', 'ASC');

                                        //Remove Record from the source
                                        ddSource.grid.store.remove(record);
                                    }
                                }

                                // Loop through the selections
                                Ext.getCmp('role-remove-button').disable();
                                Ext.getCmp('user-save-roles').enable(),
                                rolesAreDirty = true;
                                Ext.each(ddSource.dragData.selections ,addRow);
                                return(true);
                            }
                        });

                        var button = Ext.getCmp('user-activate-button');
                        button.enable();
                        if (jsonData.user.active == true)
                        {
                            setActivateButton(button,true,record);
                        }
                        else
                        {
                            setActivateButton(button,false,record);
                        }

                        Ext.getCmp('user-remove-button').enable();
                        Ext.getCmp('user-change-password').enable();

                        Ext.getCmp('user-info-login').setValue(jsonData.user.name).enable();
                        Ext.getCmp('user-info-mail').setValue(jsonData.user.mail).enable();
                        Ext.getCmp('user-info-created-at').setValue(jsonData.user.created_at).enable();
                        Ext.getCmp('user-info-blog').setValue(jsonData.user.blog).enable();

                    },
                    failure: function() {
                        Ext.Msg.alert('Status', 'Unable to show history at this time. Please try again later.');
                    }
                });
            }
        }
    });

    var comboBlog = new Ext.form.ComboBox({
        id: 'comboBlog',
        name:'User',
        store:users,
        triggerAction: 'all',
        displayField:'name',
        valueField: 'id',
        selectOnFocus: true,
        emptyText: 'Wybierz użytkownika',
        mode: 'local',
        enableKeyEvents:true,
        forceSelection: 'true',
        hiddenName : 'userId',
        listeners: {
            select: function(combo, record, index){
                Ext.Ajax.request({
                    url: '/admin_panel/users',
                    method: 'post',
                    params: {
                        user_id: record.get(combo.valueField),
                        authenticity_token: token,
                        blog: "true"
                    },
                    success: function (response){

                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        var checkbox= Ext.getCmp('blog-checkbox');
                        if (jsonData.blog.blog)
                        {

                            checkbox.suspendEvents();
                            checkbox.setValue(true).enable();
                            Ext.getCmp('blog-save').disable();
                            Ext.getCmp('blog-title').setValue(jsonData.blog.title).enable();
                            Ext.getCmp('blog-description').setValue(jsonData.blog.description).enable();
                            Ext.getCmp('blog-button').setHandler(function (){
                                window.location = jsonData.blog.link_to_blog
                            }).enable();
                        }
                        else
                        {
                            checkbox.suspendEvents();
                            checkbox.setValue(false).enable();
                            Ext.getCmp('blog-title').setValue("").disable();
                            Ext.getCmp('blog-description').setValue("").disable();
                        }
                        checkbox.resumeEvents();

                    },
                    failure: function() {
                        Ext.Msg.alert('Status', 'Unable to show history at this time. Please try again later.');
                    }
                });
            }
        }
    });

    
    var tabBar = new Ext.ButtonGroup({
        height:35,
        border: false,
        frame: false,
        minButtonWidth: 100,
        items:[
            {
                text    : 'Dodaj',
                handler : function() {
                    window.location = "/signup"
                }
            },{
                text    : 'Zapisz',
                disabled: true,
                id      : 'user-save-roles',
                handler : function() {
                    var failure = new Boolean(false);
                    var roles = new Array();
                    userRolesGrid.getStore().each(function(record){
                        roles.push(record.data.name)
                    });
                    if(rolesAreDirty == true)
                    {
                        Ext.Ajax.request({
                            url: '/admin_panel/roles',
                            method: 'post',
                            params: {
                                user_id: Ext.getCmp('combo').getValue(),
                                authenticity_token: token,
                                roles: Ext.encode(roles)
                            },
                            success: function ( result, request)
                            {
                                if(mailIsDirty == false)
                                {
                                    Ext.Msg.alert('Ok', 'Zapisano role użytkownika.');
                                    Ext.getCmp('user-save-roles').disable();
                                    rolesAreDirty = false;
                                }
                            },
                            failure: function ( result, request) {
                                if(mailIsDirty == false)
                                {
                                    Ext.Msg.alert('Błąd', 'Nie można zapisać ról użytkownika.');
                                    rolesAreDirty = false;
                                } else
                                {
                                    failure = true;
                                }
                            }
                        });
                    }
                    if(mailIsDirty == true)
                    {
                        Ext.Ajax.request({
                            url: '/admin_panel/users',
                            method: 'post',
                            params: {
                                user_id: Ext.getCmp('combo').getValue(),
                                authenticity_token: token,
                                mail: Ext.getCmp('user-info-mail').getValue()
                            },
                            success: function ( result, request)
                            {
                                if(rolesAreDirty == false)
                                {
                                    mailIsDirty = false;
                                    Ext.Msg.alert('Ok', 'Zapisano nowy adres e-mail.');
                                }
                                else if(failure == true)
                                {
                                    rolesAreDirty = false;
                                    mailIsDirty = false;
                                    Ext.Msg.alert('Błąd', 'Wystąpiły błędy podczas zapisu.');
                                }
                                else
                                {
                                    rolesAreDirty = false;
                                    mailIsDirty = false;
                                    Ext.Msg.alert('Ok', 'Zapisano zmiany.');
                                }
                            },
                            failure: function ( result, request) {
                                if(rolesAreDirty == false)
                                {
                                    rolesAreDirty = false;
                                    mailIsDirty = false;
                                    Ext.Msg.alert('Błąd', 'Nie można zapisać nowego adresu e-mail.');
                                }
                                else
                                {
                                    rolesAreDirty = false;
                                    mailIsDirty = false;
                                    Ext.Msg.alert('Błąd', 'Wystąpiły błędy podczas zapisu.');
                                }
                            
                            }
                        });
                        Ext.getCmp('user-save-roles').disable();
                    }
                }
            },{
                text    : 'Dodaj rolę',
                handler : function() {
                    Ext.Msg.prompt('Dodaj rolę', '', function(btn, text){
                        if (btn == 'ok'){
                            Ext.Ajax.request({
                                url: '/admin_panel/roles',
                                method: 'post',
                                params: {
                                    authenticity_token: token,
                                    role: text,
                                    role_action: 'save'
                                },
                                success: function ( response, request)
                                {
                                    Ext.Msg.alert('Ok', 'Zapisano rolę.');
                                    var store = allRolesGrid.getStore();
                                    var recordType =  new Ext.data.Record.create([{
                                            name: 'id'
                                        },

                                        {
                                            name: 'name',
                                            type: 'string'
                                        }]);
                                    var responseObj =Ext.util.JSON.decode(response.responseText);
                                    var record = new recordType(responseObj);
                                    store.add(record);
                                    store.sort('name', 'ASC');
                                    allRolesGrid.getView().refresh();
                                },
                                failure: function ( response, request) {
                                    Ext.Msg.alert('Błąd', 'Nie można zapisać roli.');
                                }
                            });
                        }
                    })
                }
            },{
                text    : 'Usuń rolę',
                id  : 'role-remove-button',
                disabled : true,
                handler : function() {
                    var selected = allRolesGrid.getSelectionModel().getSelected();
                    if (selected) {
                        var store = allRolesGrid.getStore();
                    }
                    else {
                        selected = userRolesGrid.getSelectionModel().getSelected();
                        if(selected){
                            var store = userRolesGrid.getStore();
                        }
                        else
                        {
                            Ext.Msg.alert('Błąd', 'Nie zaznaczono roli do usunięcia.');
                            return false;
                        }
                    }
                    Ext.Ajax.request({
                        url: '/admin_panel/roles',
                        method: 'post',
                        params: {
                            authenticity_token: token,
                            role: selected.data.name,
                            role_action: 'delete'
                        },
                        success: function ( response, request)
                        {
                            Ext.Msg.alert('Ok', 'Usunięto rolę.');
                            store.remove(selected);
                            allRolesGrid.getView().refresh();
                            userRolesGrid.getView().refresh();
                        },
                        failure: function ( response, request) {
                            Ext.Msg.alert('Błąd', 'Nie można usunąć roli.');
                        }
                    });
                }
            }]
    });

    var admin_panel = new Ext.form.FormPanel({
        layout:'fit',
        autoWidth: true,
        //        width : 600,
        height: 310,
        frame:false,
        border:false,
        applyTo: 'tab-panel-2',
        items:[{
                xtype: 'tabpanel',
                activeTab: 0,
                //            border:true,
                //            frame:true,
                border: false,
                frame: false,
                hideLabel : true,
                items:[{
                        title:'Użytkownicy',
                        border: false,
                        frame:true,
                        layout: 'column',
                        bbar : tabBar,
                        defaults: {
                            height: 250
                        },
                        items:[
                            {
                                //                    columnWidth: 0.4,
                                width : 330,
                                border: true,
                                frame:false,
                                layout: 'vbox',
                                layoutConfig:{
                                    align:'left'
                                },
                                defaults: {
                                    padding: 7
                                },
                                id: 'combo-panel',
                                items: [
                                    {
                                        items:[combo]
                                    },
                                    userInfoPanel]
                            },{
                                columnWidth: 1,
                                layout: 'vbox',
                                //                    plain: true,
                                height: 240,
                                //                    frame: true,
                                layoutConfig:{
                                    pack:'end'
                                },
                                items:[{
                                        height: 191,
                                        width: 300,
                                        border: true,
                                        //                        frame: true,
                                        layout: {
                                            type: 'hbox',
                                            align : 'top',
                                            pack: 'start'
                                        },
                                        forceLayout: true,
                                        defaults:{
                                            bodyStyle: 'padding:1px',
                                            height:175,
                                            width:130
                                        },
                                        items :[userRolesGrid , allRolesGrid]
                                    }]
                            }]

                    }
                    //            ,{
                    //                title:'Blogi',
                    //                border: false,
                    //                frame: true,
                    //                layout: 'fit',
                    //                items:[{
                    //                    border: true,
                    //                    frame:false,
                    //                    layout: 'vbox',
                    //                    layoutConfig:{
                    //                        align:'left'
                    //                    },
                    //                    defaults: {
                    //                        padding: 7
                    //                    },
                    //                    id: 'comboBlog-panel',
                    //                    items:[{
                    //                        items:[comboBlog]
                    //                    },
                    //                    blogInfoPanel]
                    //                }
                    //            ]
                    //            }
                    ,{
                        title:'Cytaty',
                        border: false,
                        frame: true,
                        layout: 'fit',
                        items:[{
                                html: 'Cytaty:<a href="/quotas"><img alt="Quota" src="/images/admin/quota.png?1247745417" title="Cytaty"/></a>'
                            }
                        ]
                    }
                ]

            }]
    });
    allRolesGrid.disable();
});
