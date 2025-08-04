CLASS zcl_if_runtest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    CLASS-METHODS generate_data.
    CLASS-METHODS create_movie.
    CLASS-METHODS read_movie.
    CLASS-METHODS update_movie.
    CLASS-METHODS delete_movie.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_if_runtest IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    generate_data( ).
*    create_movie( ).
*    update_movie( ).
*    read_movie( ).
    delete_movie( ).

    IF sy-subrc EQ 0.
      out->write( |OK| ).
    ENDIF.

  ENDMETHOD.

  METHOD create_movie.

    DATA: lt_cds_movies TYPE TABLE FOR CREATE zdd_r_movies,
          ls_cds_movie  LIKE LINE OF lt_cds_movies.

    SELECT MAX( id_movie ) FROM ztable_movies INTO @DATA(id_movie_temp).
    id_movie_temp        = id_movie_temp + 1.
    ls_cds_movie-%cid    = id_movie_temp.
    ls_cds_movie-IdMovie = id_movie_temp.
    ls_cds_movie-Title   = | title{ id_movie_temp } |.

    ls_cds_movie-%control-IdMovie = if_abap_behv=>mk-on.
    ls_cds_movie-%control-Title   = if_abap_behv=>mk-on.

    APPEND ls_cds_movie TO lt_cds_movies.

    MODIFY ENTITIES OF zdd_r_movies
    ENTITY Movie
    CREATE FROM lt_cds_movies
    FAILED   DATA(ls_create_failed)
    REPORTED DATA(ls_create_reported)
    MAPPED   DATA(ls_create_mapped).

    IF ls_create_failed IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD read_movie.

    DATA lt_cds_movies TYPE TABLE FOR READ RESULT zdd_r_movies.

    SELECT MAX( id_movie ) FROM ztable_movies INTO @DATA(id_movie_temp).

    READ ENTITIES OF zdd_r_movies
    ENTITY Movie
    ALL FIELDS WITH VALUE #( ( %tky-IdMovie = id_movie_temp ) )
    RESULT lt_cds_movies.

    IF lt_cds_movies IS NOT INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD update_movie.

    SELECT MAX( id_movie ) FROM ztable_movies INTO @DATA(id_movie_temp).

    MODIFY ENTITIES OF zdd_r_movies
    ENTITY Movie
    UPDATE
    SET FIELDS WITH VALUE #( ( %tky-IdMovie = id_movie_temp
                               Title        = |Title Updated|  ) )
    FAILED   DATA(ls_update_failed)
    REPORTED DATA(ls_update_reported)
    MAPPED   DATA(ls_update_mapped).

    IF ls_update_failed IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD delete_movie.

    SELECT MAX( id_movie ) FROM ztable_movies INTO @DATA(id_movie_temp).

    MODIFY ENTITIES OF zdd_r_movies
    ENTITY Movie
    DELETE FROM VALUE #( ( %tky-IdMovie = id_movie_temp ) )
    FAILED   DATA(ls_delete_failed)
    REPORTED DATA(ls_delete_reported)
    MAPPED   DATA(ls_delete_mapped).

    IF ls_delete_failed IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD generate_data.

    DATA ls_movie TYPE ztable_movies.

    DELETE FROM ztable_movies.
    SELECT MAX( id_movie ) FROM ztable_movies INTO @DATA(id_movie_temp).

    DO 10 TIMES.
      id_movie_temp = id_movie_temp + 1.

      ls_movie-client   = sy-mandt.
      ls_movie-id_movie = id_movie_temp.
      ls_movie-title    = | title{ id_movie_temp } |.
      INSERT ztable_movies FROM @ls_movie.
      CLEAR ls_movie.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
