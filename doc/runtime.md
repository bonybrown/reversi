
This is (possibly) the set of runtime functions that would need to be implemented
Sourced from `strings /opt/fgl-2.11.19-1169/lib/fglrun-bin | grep rts | grep -v 'rts_Op'`



## Pattern matching
```
rts_matches
rts_notMatches
rts_matchesEsc
rts_notMatchesEsc
rts_like
rts_notLike
rts_likeEsc
rts_notLikeEsc
rts_initLike
rts_validateLike
```

## ASCII / Utility
```
rts_ascii
rts_ord
rts_extend                  - how is this different to opcode 0x29 extend?
rts_initNull
rts_exprAssign
rts_using
rts_forInit
```

## String functions
```
rts_doCat
rts_Concat
```

## Dates/time
```
rts_time
rts_time1
rts_today
rts_current
rts_mdy
rts_getDate
rts_date
rts_day
rts_month
rts_year
rts_weekday
rts_datetime
rts_interval
rts_units
```

# Process control
```
rts_run
rts_runReturning
rts_runWithoutWaiting
rts_exitProgram
rts_deferQuit
rts_deferInterrupt
rts_sleep
rts_setDefaultRunInFormMode
```

## SQL / Cursors
```
rts_sql_usevarsexcept
rts_sql_usevarsinout
rts_sql_usevars
rts_sql_intovars
rts_sql_select
rts_sql_database
rts_sql_createDatabase
rts_sql_closeDatabase
rts_sql_insert
rts_sql_update
rts_sql_delete
rts_sql_load
rts_sql_unload
rts_sql_execute
rts_sql_executeuse
rts_sql_executestmt
rts_cursorClose
rts_cursorFree
rts_cursorFlush
rts_cursorPrepare
rts_cursorOpen
rts_cursorPut
rts_cursorFetchForeach
rts_cursorFetch
rts_cursorDeclare
rts_cursorDeclareForStmt
rts_sql_beginwork
rts_sql_commitwork
rts_sql_rollbackwork
rts_sql_sqlexit
rts_sql_connect
rts_sql_setConnection
rts_sql_disconnect
rts_sql_createprocedurefrom
rts_sql_setIsolationTo
rts_sql_setLockMode
rts_locateInMemory            - ??
rts_locateInFile              - ??
rts_blobFree
rts_sqlstate
rts_sqlerrmessage
```

## Screens/Forms
```
rts_construct
rts_dialogDoit
rts_dialogDestroy
rts_displayArray
rts_formFieldScrollUp
rts_formFieldScrollDown
rts_formClear
rts_formFieldClear
rts_displayTo
rts_formOpen
rts_formClose
rts_formDisplay
rts_input
rts_dialogInfield
rts_acceptDialog
rts_dialogFieldTouched
rts_dialogGetFieldBuffer
rts_dialogGetFieldBuffer2
rts_inputArray
rts_dialogCancelInsert
rts_dialogCancelDelete
rts_menuHideOption
rts_menuShowOption
rts_menuShowOptionAll
rts_menuSetAttribute
rts_menuHideOptionAll
rts_menu
rts_menuNextOption
rts_prompt
rts_opScrArr
rts_window_open
rts_window_openwithform
rts_window_clear
rts_wndClearWindowScreen
rts_wndClearScreen
rts_window_current
rts_window_close
rts_error
rts_message
rts_displayAt
rts_display
rts_optionsSet
```

## Report generation
```
rts_reportSkipToTopOfPage
rts_reportSkip
rts_reportNeed
rts_reportPause
rts_reportRegisterGroupBefore
rts_reportRegisterGroupAfter
rts_reportRegisterOrderBy
rts_reportRegisterParameter
rts_reportRegisterAggr
rts_reportEvalAggr
rts_reportAggr
rts_reportConfigure
rts_reportPrintFile
rts_reportFlush
rts_reportBeginPrint
rts_reportPrint
rts_reportPrintNamed
rts_reportPrintNamedUsing
rts_reportPrintRecord
rts_reportPrintThru
rts_reportPrintAscii
rts_reportPrintUsing
rts_reportPrintWW
rts_reportPrintWWRM
rts_reportPageNo
rts_reportLineNo
rts_reportSelect
rts_reportExit
rts_reportAscii
rts_reportRegisterOrderExternalBy
rts_reportRegisterParameterNames
```
