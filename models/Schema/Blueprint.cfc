component accessors="true" {

    property name="schemaBuilder";
    property name="grammar";
    property name="table";
    property name="commands";

    property name="columns";
    property name="dropColumns";
    property name="indexes";

    property name="ifExists" default="false";

    function init( schemaBuilder, grammar ) {
        setSchemaBuilder( schemaBuilder );
        setGrammar( grammar );

        setColumns( [] );
        setDropColumns( [] );
        setCommands( [] );
        setIndexes( [] );
        return this;
    }

    function addCommand( command, parameters = [] ) {
        variables.commands.append( new SchemaCommand( type = command, parameters = parameters ) );
        return this;
    }

    function toSql() {
        return variables.commands.map( function( command ) {
            return invoke( getGrammar(), "compile#command.getType()#", {
                blueprint = this,
                commandParameters = command.getParameters()
            } );
        } );
    }

    function addColumn() {
        var newColumn = new Column( this );
        var indexMetadata = getMetadata( newColumn );
        var functionNames = indexMetadata.functions.map( function( func ) {
            return lcase( func.name );
        } );
        for ( var arg in arguments ) {
            if ( functionNames.contains( lcase( "set#arg#" ) ) ) {
                invoke( newColumn, "set#arg#", { 1 = arguments[ arg ] } );
            }
        }
        variables.columns.append( newColumn );
        return newColumn;
    }

    function addIndex() {
        var newIndex = new TableIndex( this );
        var indexMetadata = getMetadata( newIndex );
        var functionNames = indexMetadata.functions.map( function( func ) {
            return lcase( func.name );
        } );
        for ( var arg in arguments ) {
            if ( functionNames.contains( lcase( "set#arg#" ) ) ) {
                invoke( newIndex, "set#arg#", { 1 = arguments[ arg ] } );
            }
        }
        variables.indexes.append( newIndex );
        return newIndex;
    }

    /*======================================
    =            Alter Commands            =
    ======================================*/

    function dropColumn( name ) {
        var dropColumn = new Column( this );
        var indexMetadata = getMetadata( dropColumn );
        var functionNames = indexMetadata.functions.map( function( func ) {
            return lcase( func.name );
        } );
        for ( var arg in arguments ) {
            if ( functionNames.contains( lcase( "set#arg#" ) ) ) {
                invoke( dropColumn, "set#arg#", { 1 = arguments[ arg ] } );
            }
        }
        addCommand( "dropColumn", { column = dropColumn } );
        return dropColumn;
    }

    function renameColumn( name, newColumnDefinition ) {
        addCommand( "renameColumn", { from = name, to = newColumnDefinition } );
        return this;
    }

    /*=====  End of Alter Commands  ======*/


    /*====================================
    =            Column Types            =
    ====================================*/

    function bigIncrements( name ) {
        arguments.autoIncrement = true;
        addIndex( type = "primary", column = name );
        return unsignedBigInteger( argumentCollection = arguments );
    }

    function bigInteger( name ) {
        arguments.type = "bigInteger";
        return addColumn( argumentCollection = arguments );
    }

    function bit( name, length = 1 ) {
        arguments.type = "bit";
        return addColumn( argumentCollection = arguments );
    }

    function boolean( name ) {
        arguments.length = 1;
        arguments.type = "boolean";
        return addColumn( argumentCollection = arguments );
    }

    function char( name, length = 1 ) {
        arguments.length = arguments.length > 255 ? 255 : arguments.length;
        arguments.type = "char";
        return addColumn( argumentCollection = arguments );
    }

    function date( name ) {
        arguments.type = "date";
        return addColumn( argumentCollection = arguments );
    }

    function datetime( name ) {
        arguments.type = "datetime";
        return addColumn( argumentCollection = arguments );
    }

    function decimal( name, length = 10, precision = 0 ) {
        arguments.type = "decimal";
        return addColumn( argumentCollection = arguments );
    }

    function enum( name, values ) {
        arguments.type = "enum";
        return addColumn( argumentCollection = arguments );
    }

    function float( name, length = 10, precision = 0 ) {
        arguments.type = "float";
        return addColumn( argumentCollection = arguments );
    }

    function increments( name ) {
        arguments.autoIncrement = true;
        addIndex( type = "primary", column = name );
        return unsignedInteger( argumentCollection = arguments );
    }

    function integer( name, precision = 10 ) {
        arguments.type = "integer";
        return addColumn( argumentCollection = arguments );
    }

    function json( name ) {
        arguments.type = "json";
        return addColumn( argumentCollection = arguments );
    }

    function longText( name ) {
        arguments.type = "longText";
        return addColumn( argumentCollection = arguments );
    }

    function mediumIncrements( name ) {
        arguments.autoIncrement = true;
        addIndex( type = "primary", column = name );
        return unsignedMediumInteger( argumentCollection = arguments );
    }

    function mediumInteger( name, precision = 10 ) {
        arguments.type = "mediumInteger";
        return addColumn( argumentCollection = arguments );
    }

    function mediumText( name ) {
        arguments.type = "mediumText";
        return addColumn( argumentCollection = arguments );
    }

    function morphs( name ) {
        unsignedInteger( "#name#_id" );
        string( "#name#_type" );
        addIndex(
            type = "basic",
            name = "#name#_index",
            column = [ "#name#_id", "#name#_type" ]
        );
        return this;
    }

    function nullableMorphs( name ) {
        unsignedInteger( "#name#_id" ).nullable();
        string( "#name#_type" ).nullable();
        addIndex(
            type = "basic",
            name = "#name#_index",
            column = [ "#name#_id", "#name#_type" ]
        );
        return this;
    }

    function smallIncrements( name ) {
        arguments.autoIncrement = true;
        addIndex( type = "primary", column = name );
        return unsignedSmallInteger( argumentCollection = arguments );
    }

    function smallInteger( name, precision = 10 ) {
        arguments.type = "smallInteger";
        return addColumn( argumentCollection = arguments );
    }

    function string( name, length ) {
        arguments.type = "string";
        if ( isNull( arguments.length ) ) {
            arguments.length = getSchemaBuilder().getDefaultStringLength();
        }
        return addColumn( argumentCollection = arguments );
    }

    function text( name ) {
        arguments.type = "text";
        return addColumn( argumentCollection = arguments );
    }

    function time( name ) {
        arguments.type = "time";
        return addColumn( argumentCollection = arguments );
    }

    function timestamp( name ) {
        arguments.type = "timestamp";
        return addColumn( argumentCollection = arguments );
    }

    function tinyIncrements( name ) {
        arguments.autoIncrement = true;
        addIndex( type = "primary", column = name );
        return unsignedTinyInteger( argumentCollection = arguments );
    }

    function tinyInteger( name, precision = 10 ) {
        arguments.type = "tinyInteger";
        return addColumn( argumentCollection = arguments );
    }

    function unsignedBigInteger( name ) {
        arguments.unsigned = true;
        return bigInteger( argumentCollection = arguments );
    }

    function unsignedInteger( name ) {
        arguments.unsigned = true;
        return integer( argumentCollection = arguments );
    }

    function unsignedMediumInteger( name ) {
        arguments.unsigned = true;
        return mediumInteger( argumentCollection = arguments );
    }

    function unsignedSmallInteger( name ) {
        arguments.unsigned = true;
        return smallInteger( argumentCollection = arguments );
    }

    function unsignedTinyInteger( name ) {
        arguments.unsigned = true;
        return tinyInteger( argumentCollection = arguments );
    }

    function uuid( name ) {
        arguments.type = "uuid";
        return addColumn( argumentCollection = arguments );
    }

}