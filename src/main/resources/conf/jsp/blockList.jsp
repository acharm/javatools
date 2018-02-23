<!DOCTYPE html>
<HTML>
<HEAD>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" type="text/css" href="../js/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../js/themes/icon.css" />
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../js/jquery.edatagrid.js"></script>
    <script type="text/javascript" src="../js/datagrid-cellediting.js"></script>
</HEAD>
    
<BODY>
    <table id="dog" class="easyui-datagrid" title="Block List" style="width:800px;height:250px"></table>
    <BUTTON ID="SAVEBLOCKBTN" STYLE="POSITION:ABSOLUTE; LEFT:900PX; TOP:50PX">SAVE</BUTTON>
    <BUTTON ID="SENDBLOCKBTN" STYLE="POSITION:ABSOLUTE; LEFT:900PX; TOP:100PX">SEND</BUTTON>
    <table id="cat" class="easyui-datagrid" title="Item List In single Block" style="width:1180px;height:250px" singleSelect="true"></table>
</BODY>

<script type="text/javascript">
$(function() {alert("sth~~");
    getData();
});

function getData() {
    // alert("编码有问题");
    $('#dog').datagrid({
        url: 'getAllBlock',
        singleSelect: true, 
        columns:[[
            {field:'name',title:'name',width:300},
            {field:'area',title:'area',width:100},
            {field:'action',title:'action',width:100},
            {field:'startAddress',title:'startAddress',width:100},
            {field:'points',title:'points',width:100}
        ]],
        onClickRow: function(rowIndex, rowData) {
            $('#cat').datagrid({
                data: rowData["itemList"],
                width: 1180,
                columns: [[
                    {field:'block', title:'parent', width:300},
                    {field:'name',  title:'name',   width:300},
                    {field:'offset',title:'offset', width:100},
                    {field:'point', title:'point',  width:100},
                    {field:'type',  title:'type',   width:100},
                    {field:'value', title:'value',  width:100, editor:'text'},
                    {field:'action',title:'Action', width:100, align:'center',
                        formatter:function(value, row, index) {
                            var ed = $('#cat').datagrid('getEditor', {index:index,field:value});

                            if (row.editing) {
                                var rowBlock = row['block'];
                                var rowName = row['name'];
                                var s = '<a href="javascript:void(0)" onclick="saverow(\''+rowBlock+'\', \''+rowName+'\', \''+index+'\')">Save</a> ';
                                var c = '<a href="javascript:void(0)" onclick="cancelrow(this)">Cancel</a>';
                                return  s + c;
                            } else {
                                var e = '<a href="javascript:void(0)" onclick="editrow(this)">Edit</a> ';
                                return e;
                            }
                        }
                    }
                ]],
                onEndEdit:function(index, row){
                    var ed = $(this).datagrid('getEditor', {
                        index: index,
                        field: 'value'
                    });
                },
                onBeforeEdit:function(index, row) {
                    row.editing = true;
                    $(this).datagrid('refreshRow', index);
                },
                onAfterEdit:function(index, row){
                    row.editing = false;
                    $(this).datagrid('refreshRow', index);
                },
                onCancelEdit:function(index,row) {
                    row.editing = false;
                    $(this).datagrid('refreshRow', index);
                }
            });
        }
    });
}

function getRowIndex(target){
    var tr = $(target).closest('tr.datagrid-row');
    return parseInt(tr.attr('datagrid-row-index'));
}
function editrow(target) {
    $('#cat').datagrid('beginEdit', getRowIndex(target));
}

function saverow(rowBlock, rowName, index) {
    $("#cat").datagrid('endEdit', index);
    var rows = $('#cat').datagrid("getRows");
    var newValue = rows[index]['value'];
}
function cancelrow(target) {
    $('#cat').datagrid('cancelEdit', getRowIndex(target));
}

$("#SENDBLOCKBTN").click(function() {
    var row = $('#dog').datagrid('getSelected');
    if(!row) {
        alert("PLEASE CHOOSE THE BBBBLOCK~~");
    }else {
    	var size = row['itemList'].length;
    	for(var i = 0; i < size; i++) {
    		$("#cat").datagrid('endEdit', i);
    	}
    	var data = (function() {
            var resultData = [];
            var itemRowVal = $('#cat').datagrid("getRows");
            for(var i = 0; i < size; i++) {
                var dItem = {};
                dItem['blockName'] = row['name'];
                var itemName = itemRowVal[i]['name'];
                dItem['itemName'] = itemName;
                var itemValue = itemRowVal[i]['value'];
                dItem['itemValue'] = itemValue;
                resultData[resultData.length] = dItem;
            }
            return resultData;
        }());

        $.ajax({
            url : 'updateBlockItemsValIntoPlc',
            data: JSON.stringify(data),
            dataType:"json",
            contentType: "application/json",
            type: "POST",
            success: function(data) {
                if(data['status'] == 'SUCCESS') {
                    $("#dog").datagrid("reload", {});
                }
            }
        });
    }
});

$("#SAVEBLOCKBTN").click(function() {
    var row = $('#dog').datagrid('getSelected');
    if(!row) {
        alert("PLEASE CHOOSE THE BBBBLOCK~~");
    }else {
        var size = row['itemList'].length;
        for(var i = 0; i < size; i++) {
            $("#cat").datagrid('endEdit', i);
        }
        var data = (function() {
            var resultData = [];
            var itemRowVal = $('#cat').datagrid("getRows");
            for(var i = 0; i < size; i++) {
                var dItem = {};
                dItem['blockName'] = row['name'];
                var itemName = itemRowVal[i]['name'];
                dItem['itemName'] = itemName;
                var itemValue = itemRowVal[i]['value'];
                dItem['itemValue'] = itemValue;
                resultData[resultData.length] = dItem;
            }
            return resultData;
        }());

        $.ajax({
            url : 'updateBlockItemsVal',
            data: JSON.stringify(data),
            dataType:"json",
            contentType: "application/json",
            type: "POST",
            success: function(data) {
                if(data['status'] == 'SUCCESS') {
                    $("#dog").datagrid("reload", {});
                    var rowIndex = $('#dog').datagrid('getRowIndex', row);
                    $('#dog').datagrid('selectRow', rowIndex);
                }
            }
        });
        
    }
});

</script>
</HTML>