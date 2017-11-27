set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.3.00.05'
,p_default_workspace_id=>14861999474993887539
,p_default_application_id=>42424242
,p_default_owner=>'ORACOOLAPEX'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/oracoolapex_datedropper
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(31245697109785470074)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'ORACOOLAPEX.DATEDROPPER'
,p_display_name=>'Date Dropper'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#server/lib/Datedropper3/datedropper#MIN#.js',
'#PLUGIN_FILES#server/js/apexdatedropper#MIN#.js'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#server/lib/Datedropper3/datedropper#MIN#.css',
'#PLUGIN_FILES#server/css/oracoolapex_datedropper.css'))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'procedure render_datedropper (',
'  p_item   in            apex_plugin.t_item,',
'  p_plugin in            apex_plugin.t_plugin,',
'  p_param  in            apex_plugin.t_item_render_param,',
'  p_result in out nocopy apex_plugin.t_item_render_result )',
'is',
'  l_default_date         varchar2(10);',
'  l_disabled_days        varchar2(4000);',
'  l_format               varchar2(6);',
'  l_fx                   varchar2(5);',
'  l_fx_mobile            varchar2(5);',
'  l_init_set             varchar2(5);',
'  l_lang                 varchar2(2);',
'  l_large_mode           varchar2(5);',
'  l_large_default        varchar2(5);',
'  l_lock                 varchar2(5);',
'  l_jump                 number;',
'  l_max_year             varchar2(4);',
'  l_min_year             varchar2(4);',
'  l_modal                varchar2(5);',
'  l_theme                varchar2(10);',
'  l_translate_mode       varchar2(5);',
'  l_html                 varchar2(4000);',
'  --',
'  --Convert Yes/No To True/False VARCHAR2 Type',
'  --',
'  function yn_to_tf_vc ( p_yn  in varchar2 )',
'  return varchar2',
'  is',
'  begin',
'    case when lower(p_yn) = ''y'' then return ''true'';',
'    else return ''false'';',
'    end case;',
'  end yn_to_tf_vc;',
'begin',
'  --',
'  --Component-Level Custom Attributes',
'  --',
'  l_default_date    := p_item.attribute_01;',
'  l_disabled_days   := nvl(p_item.attribute_02,''false'');',
'  l_init_set        := yn_to_tf_vc(p_item.attribute_03);',
'  l_large_mode      := yn_to_tf_vc(p_item.attribute_04);',
'  l_large_default   := yn_to_tf_vc(p_item.attribute_05);',
'  l_lock            := nvl(p_item.attribute_06,''false'');',
'  l_jump            := p_item.attribute_07;',
'  l_max_year        := p_item.attribute_08;',
'  l_min_year        := p_item.attribute_09;',
'  l_modal           := yn_to_tf_vc(p_item.attribute_10);',
'  --',
'  --Application-Level Custom Attributes',
'  --',
'  l_format          := p_plugin.attribute_01;',
'  l_fx              := yn_to_tf_vc(p_plugin.attribute_02);',
'  l_fx_mobile       := yn_to_tf_vc(p_plugin.attribute_03);',
'  l_lang            := p_plugin.attribute_04;',
'  l_theme           := p_plugin.attribute_05;',
'  l_translate_mode  := yn_to_tf_vc(p_plugin.attribute_06);',
'  --',
'  --Add Theme CSS Files',
'  --',
'  case l_theme',
'    when ''vita_dark'' then',
'      apex_css.add_file (',
'        p_name      => ''server/css/vita_dark'',',
'        p_directory => p_plugin.file_prefix );',
'    when ''vita_red'' then',
'      apex_css.add_file (',
'        p_name      => ''server/css/vita_red'',',
'        p_directory => p_plugin.file_prefix );',
'    when ''vita_slate'' then',
'      apex_css.add_file (',
'        p_name      => ''server/css/vita_slate'',',
'        p_directory => p_plugin.file_prefix );',
'    else',
'      apex_css.add_file (',
'        p_name      => ''server/css/vita'',',
'        p_directory => p_plugin.file_prefix );',
'  end case;',
'  --',
'  --Debug Mode',
'  --',
'  if apex_application.g_debug then',
'    apex_plugin_util.debug_page_item (',
'      p_plugin              => p_plugin,',
'      p_page_item           => p_item,',
'      p_value               => p_param.value,',
'      p_is_readonly         => p_param.is_readonly,',
'      p_is_printer_friendly => p_param.is_printer_friendly );',
'  end if;',
'  --',
'  --Printer Friendly Display',
'  --',
'  if p_param.is_printer_friendly then',
'    apex_plugin_util.print_display_only (',
'      p_item_name           => p_item.name,',
'      p_display_value       => p_param.value,',
'      p_show_line_breaks    => false,',
'      p_escape              => true,',
'      p_attributes          => p_item.element_attributes );',
'',
'    p_result.is_navigable := false;',
'  --',
'  --Read Only Display',
'  --',
'  elsif p_param.is_readonly then',
'    apex_plugin_util.print_hidden_if_readonly (',
'      p_item_name           => p_item.name,',
'      p_value               => p_param.value,',
'      p_is_readonly         => p_param.is_readonly,',
'      p_is_printer_friendly => p_param.is_printer_friendly );',
'',
'    p_result.is_navigable := false;',
'  else',
'    l_html := ''<input type="text" id="'' || p_item.name || ''" name="'' || p_item.name || ''" '';',
'    ',
'    if l_default_date   is not null then l_html := l_html || ''data-default-date="''   || l_default_date   || ''" ''; end if;',
'    if l_disabled_days  is not null then l_html := l_html || ''data-disabled-days="''  || l_disabled_days  || ''" ''; end if;',
'    if l_format         is not null then l_html := l_html || ''data-format="''         || l_format         || ''" ''; end if;',
'    if l_fx             is not null then l_html := l_html || ''data-fx="''             || l_fx             || ''" ''; end if;',
'    if l_fx_mobile      is not null then l_html := l_html || ''data-fx-mobile="''      || l_fx_mobile      || ''" ''; end if;',
'    if l_init_set       is not null then l_html := l_html || ''data-init-set="''       || l_init_set       || ''" ''; end if;',
'    if l_lang           is not null then l_html := l_html || ''data-lang="''           || l_lang           || ''" ''; end if;',
'    if l_large_mode     is not null then l_html := l_html || ''data-large-mode="''     || l_large_mode     || ''" ''; end if;',
'    if l_large_default  is not null then l_html := l_html || ''data-large-default="''  || l_large_default  || ''" ''; end if;',
'    if l_lock           is not null then l_html := l_html || ''data-lock="''           || l_lock           || ''" ''; end if;',
'    if l_jump           is not null then l_html := l_html || ''data-jump="''           || l_jump           || ''" ''; end if;',
'    if l_max_year       is not null then l_html := l_html || ''data-max-year="''       || l_max_year       || ''" ''; end if;',
'    if l_min_year       is not null then l_html := l_html || ''data-min-year="''       || l_min_year       || ''" ''; end if;',
'    if l_modal          is not null then l_html := l_html || ''data-modal="''          || l_modal          || ''" ''; end if;',
'    if l_theme          is not null then l_html := l_html || ''data-theme="''          || l_theme          || ''" ''; end if;',
'    if l_translate_mode is not null then l_html := l_html || ''data-translate-mode="'' || l_translate_mode || ''" ''; end if;',
'',
'    l_html := l_html || ''/>'';',
'',
'    sys.htp.p(l_html);',
'',
'    apex_javascript.add_onload_code (',
'      p_code => ''apexDateDropper.initDateDropper('' ||',
'                   apex_javascript.add_value (',
'                       p_value     => p_item.name,',
'                       p_add_comma => false )      || '');'' );',
'',
'    p_result.is_navigable := true;',
'  end if;',
'exception',
'  when others then',
'    raise;',
'end render_datedropper;'))
,p_api_version=>2
,p_render_function=>'render_datedropper'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:SOURCE:ELEMENT:WIDTH:ELEMENT_OPTION:ICON'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0.1'
,p_about_url=>'https://github.com/OraCoolAPEX/apex-plugin-datedropper'
,p_files_version=>51
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31250689421144703734)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Format'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'m-d-Y'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The date format the picker will write on the selected input.</p>',
'<p>Default: "m-d-Y"</p>',
'<p>Example: data-format="F S, Y"</p>',
'<p>',
'  Key     Description               Result  <br />',
'  M       Short month               Jan     <br />',
'  F       Long month                January <br />',
'  m       Numeric month             01-12   <br />',
'  n       Non-padded numeric month  1-12    <br />',
'  Y       Long numeric year         2015    <br />',
'  d       Padded numeric day        01-31   <br />',
'  j       Non-Padded Numeric day    1-31    <br />',
'  D       Short day-of-week         Sun     <br />',
'  l       Long day-of-week          Sunday',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31251401712535795638)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'FX'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If set to true, the picker will run an initial state animation and all user changes are animated.</p>',
'<p>Default: true</p>',
'<p>Example: data-fx="false"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31251621442590807434)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'FX Mobile'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Animations could be very slow on some older smartphones. To prevent this, set this option to false to disable animations on any mobile viewport.</p>',
'<p>Default: true</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31251816129936814084)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Lang'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'en'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Languages used for months and days of the week.</p>',
'<p>Default: en</p>',
'<p>Example: data-lang="it"</p>',
'<p>',
'  Value  Result     <br />',
'  ar     Arabic     <br />',
'  it     Italian    <br />',
'  hu     Hungarian  <br />',
'  gr     Greek      <br />',
'  es     Espanol    <br />',
'  da     Dansk      <br />',
'  de     Deutsch    <br />',
'  nl     Dutch      <br />',
'  fr     Francais   <br />',
'  pl     Polski     <br />',
'  pt     Portuguese <br />',
'  si     Slovenian  <br />',
'  uk     Ukrainian  <br />',
'  ru     Russian    <br />',
'  tr     Turkish    <br />',
'  ko     Korean     <br />',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31251820713164816029)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>10
,p_display_value=>'Arabic'
,p_return_value=>'ar'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252629417086860442)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>20
,p_display_value=>'Dansk'
,p_return_value=>'da'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252630566001861101)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>30
,p_display_value=>'Deutsch'
,p_return_value=>'de'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252693846950847836)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>40
,p_display_value=>'Dutch'
,p_return_value=>'nl'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31253296427610875200)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>50
,p_display_value=>'English'
,p_return_value=>'en'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252667442443845714)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>60
,p_display_value=>'Espanol'
,p_return_value=>'es'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252694759388848561)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>70
,p_display_value=>'Francais'
,p_return_value=>'fr'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252667097695845061)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>80
,p_display_value=>'Greek'
,p_return_value=>'gr'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252625153148858408)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>90
,p_display_value=>'Hungarian'
,p_return_value=>'hu'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252650071443843463)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>100
,p_display_value=>'Italian'
,p_return_value=>'it'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252729103001869072)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>110
,p_display_value=>'Korean'
,p_return_value=>'ko'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252703974809863349)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>120
,p_display_value=>'Polski'
,p_return_value=>'pl'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252705393572864164)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>130
,p_display_value=>'Portuguese'
,p_return_value=>'pt'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252707962644866241)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>140
,p_display_value=>'Russian'
,p_return_value=>'ru'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252706295888864824)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>150
,p_display_value=>'Slovenian'
,p_return_value=>'si'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252716984787866963)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>160
,p_display_value=>'Turkish'
,p_return_value=>'tr'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31252706973994865534)
,p_plugin_attribute_id=>wwv_flow_api.id(31251816129936814084)
,p_display_sequence=>170
,p_display_value=>'Ukrainian'
,p_return_value=>'uk'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31264244109069830869)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Theme'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'vita'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Set the name of style that you have assigned on the stylesheet generated by the theme generator.</p>',
'<p>Example: data-theme="my-style"</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31264251799072834887)
,p_plugin_attribute_id=>wwv_flow_api.id(31264244109069830869)
,p_display_sequence=>10
,p_display_value=>'Vita'
,p_return_value=>'vita'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31264265751039835894)
,p_plugin_attribute_id=>wwv_flow_api.id(31264244109069830869)
,p_display_sequence=>20
,p_display_value=>'Vita-Dark'
,p_return_value=>'vita_dark'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31264282646840837018)
,p_plugin_attribute_id=>wwv_flow_api.id(31264244109069830869)
,p_display_sequence=>30
,p_display_value=>'Vita-Red'
,p_return_value=>'vita_red'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(31264284685149838303)
,p_plugin_attribute_id=>wwv_flow_api.id(31264244109069830869)
,p_display_sequence=>40
,p_display_value=>'Vita-Slate'
,p_return_value=>'vita_slate'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31264909701055857867)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Translate Mode'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If it''s set to true, you can change the language by clicking on the icon at the bottom.</p>',
'<p>Default: false</p>',
'<p>Example: data-translate-mode="true"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31248965859117643566)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Default Date'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This option offers the possibility to set a starting date. Please note that you must follow this specific format (mm-dd-yyyy) to allow the matching to recognize month, day and year.</p>',
'<p>Default: CURRENT DATE</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31249770901113697215)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Disabled Days'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This option offers the possibility to set a string of disabled days. So, separete all days by comma and the picker will convert them into an array. Please note that you must follow this specific format (mm/dd/yyyy) to allow the matching to recogni'
||'ze month, day and year.</p>',
'<p>Default: false</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31251655255035802322)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Init Set'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This option changes the input value automatically, by default. Set to false to prevent it.</p>',
'<p>Example: data-init-set="false"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31254443045274940964)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Large Mode'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This option enables to switch the size of the picker by clicking on the icon at the bottom or clicking on the day block.</p>',
'<p>Default: false</p>',
'<p>Example: data-large-mode="true"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31254514688682939318)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Large Default'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If "data-large-mode" is set to true, this option shows the large view by default.</p>',
'<p>Default: false</p>',
'<p>Example: data-large-default="true"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31263416115982740482)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Lock'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>lock: This option sets the date limit based on the assigned variable. If you set to "from", you can''t select a date earlier than the current date. Opposed to this behavior, if it''s set to "to", you can not select a date after the current date.</p>',
'<p>Default: false</p>',
'<p>Example: data-lock="from"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31263518313010760237)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Jump'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'10'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>It groups years based on the value set(multiple). This option is enabled when you click on the year block, to accellerate the transition between years.</p>',
'<p>Default: 10</p>',
'<p>Example: data-jump="4"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31264115148475795059)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Max Year'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The highest year that the control will allow.</p>',
'<p>Default: CURRENT YEAR</p>',
'<p>Example: data-max-year="2030"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31264142073915813682)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Min Year'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The lowest year that the control will allow.</p>',
'<p>Default: 1970</p>',
'<p>Example: data-min-year="1800"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(31264202840915820063)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Modal'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If this option is set to true, the picker will be displayed centered, with a dark overlay in background.</p>',
'<p>Default: false</p>',
'<p>Example: data-modal="true"</p>'))
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(37340905277796211230)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_name=>'apex-datedropper-change'
,p_display_name=>'APEX Date Dropper - Change'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D6D206C69207B0D0A2020666F6E742D73697A653A20333270783B0D0A20206C696E652D6865696768743A20363070783B0D0A7D0D0A0D0A6469762E64617465';
wwv_flow_api.g_varchar2_table(2) := '64726F70706572202E7069636B657220756C2E7069636B2E7069636B2D64206C69207B0D0A20206C696E652D6865696768743A20383070783B0D0A2020666F6E742D73697A653A20363470783B0D0A7D0D0A0D0A6469762E6461746564726F7070657220';
wwv_flow_api.g_varchar2_table(3) := '2E7069636B657220756C2E7069636B2E7069636B2D79206C69207B0D0A20206C696E652D6865696768743A20363070783B0D0A2020666F6E742D73697A653A20323470783B0D0A7D0D0A0D0A6469762E6461746564726F70706572202E7069636B657220';
wwv_flow_api.g_varchar2_table(4) := '756C2E7069636B2E7069636B2D6C206C69207B0D0A20206C696E652D6865696768743A20363070783B0D0A2020666F6E742D73697A653A20313870783B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395081270970574685)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/css/oracoolapex_datedropper.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A0A09494E535452554354494F4E53202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0A';
wwv_flow_api.g_varchar2_table(2) := '20200A2020312E206C696E6B2074686973207374796C65736865657420696E207468652068656164206F6620796F75722048544D4C0A202009203C6C696E6B20687265663D22594F555220504154482F766974612E637373222072656C3D227374796C65';
wwv_flow_api.g_varchar2_table(3) := '73686565742220747970653D22746578742F63737322202F3E0A20202020200A2020322E20536574207468652066696C65206E616D6520617320646174612D7468656D6520617474726962757465206F6E20796F757220696E7075740A202009203C696E';
wwv_flow_api.g_varchar2_table(4) := '70757420646174612D7468656D653D227669746122202F3E0A20202020200A2020332E20546861742773206974210A20200A20205768656E20796F752072756E2073637269707420746865207374796C652077696C6C206265206175746F6D6174696361';
wwv_flow_api.g_varchar2_table(5) := '6C6C79206170706C6965642E0A0A2A2F0A6469762E6461746564726F707065722E76697461207B0A2020626F726465722D7261646975733A203870783B0A202077696474683A2031383070783B0A7D0A6469762E6461746564726F707065722E76697461';
wwv_flow_api.g_varchar2_table(6) := '202E7069636B6572207B0A2020626F726465722D7261646975733A203870783B0A2020626F782D736861646F773A20302030203332707820307078207267626128302C20302C20302C20302E31293B0A7D0A6469762E6461746564726F707065722E7669';
wwv_flow_api.g_varchar2_table(7) := '7461202E7069636B2D6C207B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A203870783B0A2020626F726465722D626F74746F6D2D72696768742D7261646975733A203870783B0A7D0A6469762E6461746564726F707065722E';
wwv_flow_api.g_varchar2_table(8) := '766974613A6265666F72652C0A6469762E6461746564726F707065722E76697461202E7069636B2D7375626D69742C0A6469762E6461746564726F707065722E76697461202E7069636B2D6C672D62202E7069636B2D736C3A6265666F72652C0A646976';
wwv_flow_api.g_varchar2_table(9) := '2E6461746564726F707065722E76697461202E7069636B2D6D2C0A6469762E6461746564726F707065722E76697461202E7069636B2D6C672D68207B0A20206261636B67726F756E642D636F6C6F723A20233035373363653B0A7D0A6469762E64617465';
wwv_flow_api.g_varchar2_table(10) := '64726F707065722E76697461202E7069636B2D792E7069636B2D6A756D702C0A6469762E6461746564726F707065722E76697461202E7069636B206C69207370616E2C0A6469762E6461746564726F707065722E76697461202E7069636B2D6C672D6220';
wwv_flow_api.g_varchar2_table(11) := '2E7069636B2D776B652C0A6469762E6461746564726F707065722E76697461202E7069636B2D62746E207B0A2020636F6C6F723A20233035373363653B0A7D0A6469762E6461746564726F707065722E76697461202E7069636B65722C0A6469762E6461';
wwv_flow_api.g_varchar2_table(12) := '746564726F707065722E76697461202E7069636B2D6C207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E76697461202E7069636B65722C0A6469762E6461746564726F707065722E76';
wwv_flow_api.g_varchar2_table(13) := '697461202E7069636B2D6172772C0A6469762E6461746564726F707065722E76697461202E7069636B2D6C207B0A2020636F6C6F723A20233444344434443B0A7D0A6469762E6461746564726F707065722E76697461202E7069636B2D6D2C0A6469762E';
wwv_flow_api.g_varchar2_table(14) := '6461746564726F707065722E76697461202E7069636B2D6D202E7069636B2D6172772C0A6469762E6461746564726F707065722E76697461202E7069636B2D6C672D682C0A6469762E6461746564726F707065722E76697461202E7069636B2D6C672D62';
wwv_flow_api.g_varchar2_table(15) := '202E7069636B2D736C2C0A6469762E6461746564726F707065722E76697461202E7069636B2D7375626D6974207B0A2020636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E766974612E7069636B65722D74696E793A626566';
wwv_flow_api.g_varchar2_table(16) := '6F72652C0A6469762E6461746564726F707065722E766974612E7069636B65722D74696E79202E7069636B2D6D207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E766974612E706963';
wwv_flow_api.g_varchar2_table(17) := '6B65722D74696E79202E7069636B2D6D2C0A6469762E6461746564726F707065722E766974612E7069636B65722D74696E79202E7069636B2D6D202E7069636B2D617277207B0A2020636F6C6F723A20233444344434443B0A7D0A6469762E6461746564';
wwv_flow_api.g_varchar2_table(18) := '726F707065722E766974612E7069636B65722D6C6B64202E7069636B2D7375626D6974207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A2020636F6C6F723A20233444344434443B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395081597293574686)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/css/vita.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A0A09494E535452554354494F4E53202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0A';
wwv_flow_api.g_varchar2_table(2) := '20200A2020312E206C696E6B2074686973207374796C65736865657420696E207468652068656164206F6620796F75722048544D4C0A202009203C6C696E6B20687265663D22594F555220504154482F766974615F6461726B2E637373222072656C3D22';
wwv_flow_api.g_varchar2_table(3) := '7374796C6573686565742220747970653D22746578742F63737322202F3E0A20202020200A2020322E20536574207468652066696C65206E616D6520617320646174612D7468656D6520617474726962757465206F6E20796F757220696E7075740A2020';
wwv_flow_api.g_varchar2_table(4) := '09203C696E70757420646174612D7468656D653D22766974615F6461726B22202F3E0A20202020200A2020332E20546861742773206974210A20200A20205768656E20796F752072756E2073637269707420746865207374796C652077696C6C20626520';
wwv_flow_api.g_varchar2_table(5) := '6175746F6D61746963616C6C79206170706C6965642E0A0A2A2F0A6469762E6461746564726F707065722E766974615F6461726B207B0A2020626F726465722D7261646975733A203870783B0A202077696474683A2031383070783B0A7D0A6469762E64';
wwv_flow_api.g_varchar2_table(6) := '61746564726F707065722E766974615F6461726B202E7069636B6572207B0A2020626F726465722D7261646975733A203870783B0A2020626F782D736861646F773A20302030203332707820307078207267626128302C20302C20302C20302E31293B0A';
wwv_flow_api.g_varchar2_table(7) := '7D0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D6C207B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A203870783B0A2020626F726465722D626F74746F6D2D72696768742D726164697573';
wwv_flow_api.g_varchar2_table(8) := '3A203870783B0A7D0A6469762E6461746564726F707065722E766974615F6461726B3A6265666F72652C0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D7375626D69742C0A6469762E6461746564726F707065722E76';
wwv_flow_api.g_varchar2_table(9) := '6974615F6461726B202E7069636B2D6C672D62202E7069636B2D736C3A6265666F72652C0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D6D2C0A6469762E6461746564726F707065722E766974615F6461726B202E70';
wwv_flow_api.g_varchar2_table(10) := '69636B2D6C672D68207B0A20206261636B67726F756E642D636F6C6F723A20233332333333363B0A7D0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D792E7069636B2D6A756D702C0A6469762E6461746564726F7070';
wwv_flow_api.g_varchar2_table(11) := '65722E766974615F6461726B202E7069636B206C69207370616E2C0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D6C672D62202E7069636B2D776B652C0A6469762E6461746564726F707065722E766974615F646172';
wwv_flow_api.g_varchar2_table(12) := '6B202E7069636B2D62746E207B0A2020636F6C6F723A20233332333333363B0A7D0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B65722C0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B';
wwv_flow_api.g_varchar2_table(13) := '2D6C207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B65722C0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D';
wwv_flow_api.g_varchar2_table(14) := '6172772C0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D6C207B0A2020636F6C6F723A20233444344434443B0A7D0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D6D2C0A6469762E';
wwv_flow_api.g_varchar2_table(15) := '6461746564726F707065722E766974615F6461726B202E7069636B2D6D202E7069636B2D6172772C0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D6C672D682C0A6469762E6461746564726F707065722E766974615F';
wwv_flow_api.g_varchar2_table(16) := '6461726B202E7069636B2D6C672D62202E7069636B2D736C2C0A6469762E6461746564726F707065722E766974615F6461726B202E7069636B2D7375626D6974207B0A2020636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E';
wwv_flow_api.g_varchar2_table(17) := '766974615F6461726B2E7069636B65722D74696E793A6265666F72652C0A6469762E6461746564726F707065722E766974615F6461726B2E7069636B65722D74696E79202E7069636B2D6D207B0A20206261636B67726F756E642D636F6C6F723A202346';
wwv_flow_api.g_varchar2_table(18) := '46463B0A7D0A6469762E6461746564726F707065722E766974615F6461726B2E7069636B65722D74696E79202E7069636B2D6D2C0A6469762E6461746564726F707065722E766974615F6461726B2E7069636B65722D74696E79202E7069636B2D6D202E';
wwv_flow_api.g_varchar2_table(19) := '7069636B2D617277207B0A2020636F6C6F723A20233444344434443B0A7D0A6469762E6461746564726F707065722E766974615F6461726B2E7069636B65722D6C6B64202E7069636B2D7375626D6974207B0A20206261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(20) := '723A20234646463B0A2020636F6C6F723A20233444344434443B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395081944883574687)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/css/vita_dark.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A0A09494E535452554354494F4E53202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0A';
wwv_flow_api.g_varchar2_table(2) := '20200A2020312E206C696E6B2074686973207374796C65736865657420696E207468652068656164206F6620796F75722048544D4C0A202009203C6C696E6B20687265663D22594F555220504154482F766974615F7265642E637373222072656C3D2273';
wwv_flow_api.g_varchar2_table(3) := '74796C6573686565742220747970653D22746578742F63737322202F3E0A20202020200A2020322E20536574207468652066696C65206E616D6520617320646174612D7468656D6520617474726962757465206F6E20796F757220696E7075740A202009';
wwv_flow_api.g_varchar2_table(4) := '203C696E70757420646174612D7468656D653D22766974615F72656422202F3E0A20202020200A2020332E20546861742773206974210A20200A20205768656E20796F752072756E2073637269707420746865207374796C652077696C6C206265206175';
wwv_flow_api.g_varchar2_table(5) := '746F6D61746963616C6C79206170706C6965642E0A0A2A2F0A6469762E6461746564726F707065722E766974615F726564207B0A2020626F726465722D7261646975733A203870783B0A202077696474683A2031383070783B0A7D0A6469762E64617465';
wwv_flow_api.g_varchar2_table(6) := '64726F707065722E766974615F726564202E7069636B6572207B0A2020626F726465722D7261646975733A203870783B0A2020626F782D736861646F773A20302030203332707820307078207267626128302C20302C20302C20302E31293B0A7D0A6469';
wwv_flow_api.g_varchar2_table(7) := '762E6461746564726F707065722E766974615F726564202E7069636B2D6C207B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A203870783B0A2020626F726465722D626F74746F6D2D72696768742D7261646975733A20387078';
wwv_flow_api.g_varchar2_table(8) := '3B0A7D0A6469762E6461746564726F707065722E766974615F7265643A6265666F72652C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D7375626D69742C0A6469762E6461746564726F707065722E766974615F726564';
wwv_flow_api.g_varchar2_table(9) := '202E7069636B2D6C672D62202E7069636B2D736C3A6265666F72652C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D6D2C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D6C672D68207B';
wwv_flow_api.g_varchar2_table(10) := '0A20206261636B67726F756E642D636F6C6F723A20236461316231623B0A7D0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D792E7069636B2D6A756D702C0A6469762E6461746564726F707065722E766974615F726564';
wwv_flow_api.g_varchar2_table(11) := '202E7069636B206C69207370616E2C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D6C672D62202E7069636B2D776B652C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D62746E207B0A';
wwv_flow_api.g_varchar2_table(12) := '2020636F6C6F723A20236461316231623B0A7D0A6469762E6461746564726F707065722E766974615F726564202E7069636B65722C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D6C207B0A20206261636B67726F756E';
wwv_flow_api.g_varchar2_table(13) := '642D636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E766974615F726564202E7069636B65722C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D6172772C0A6469762E6461746564726F7070';
wwv_flow_api.g_varchar2_table(14) := '65722E766974615F726564202E7069636B2D6C207B0A2020636F6C6F723A20233444344434443B0A7D0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D6D2C0A6469762E6461746564726F707065722E766974615F726564';
wwv_flow_api.g_varchar2_table(15) := '202E7069636B2D6D202E7069636B2D6172772C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D6C672D682C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D6C672D62202E7069636B2D73';
wwv_flow_api.g_varchar2_table(16) := '6C2C0A6469762E6461746564726F707065722E766974615F726564202E7069636B2D7375626D6974207B0A2020636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E766974615F7265642E7069636B65722D74696E793A626566';
wwv_flow_api.g_varchar2_table(17) := '6F72652C0A6469762E6461746564726F707065722E766974615F7265642E7069636B65722D74696E79202E7069636B2D6D207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E76697461';
wwv_flow_api.g_varchar2_table(18) := '5F7265642E7069636B65722D74696E79202E7069636B2D6D2C0A6469762E6461746564726F707065722E766974615F7265642E7069636B65722D74696E79202E7069636B2D6D202E7069636B2D617277207B0A2020636F6C6F723A20233444344434443B';
wwv_flow_api.g_varchar2_table(19) := '0A7D0A6469762E6461746564726F707065722E766974615F7265642E7069636B65722D6C6B64202E7069636B2D7375626D6974207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A2020636F6C6F723A20233444344434443B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395082300020574688)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/css/vita_red.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A0A09494E535452554354494F4E53202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0A';
wwv_flow_api.g_varchar2_table(2) := '20200A2020312E206C696E6B2074686973207374796C65736865657420696E207468652068656164206F6620796F75722048544D4C0A202009203C6C696E6B20687265663D22594F555220504154482F766974615F736C6174652E637373222072656C3D';
wwv_flow_api.g_varchar2_table(3) := '227374796C6573686565742220747970653D22746578742F63737322202F3E0A20202020200A2020322E20536574207468652066696C65206E616D6520617320646174612D7468656D6520617474726962757465206F6E20796F757220696E7075740A20';
wwv_flow_api.g_varchar2_table(4) := '2009203C696E70757420646174612D7468656D653D22766974615F736C61746522202F3E0A20202020200A2020332E20546861742773206974210A20200A20205768656E20796F752072756E2073637269707420746865207374796C652077696C6C2062';
wwv_flow_api.g_varchar2_table(5) := '65206175746F6D61746963616C6C79206170706C6965642E0A0A2A2F0A6469762E6461746564726F707065722E766974615F736C617465207B0A2020626F726465722D7261646975733A203870783B0A202077696474683A2031383070783B0A7D0A6469';
wwv_flow_api.g_varchar2_table(6) := '762E6461746564726F707065722E766974615F736C617465202E7069636B6572207B0A2020626F726465722D7261646975733A203870783B0A2020626F782D736861646F773A20302030203332707820307078207267626128302C20302C20302C20302E';
wwv_flow_api.g_varchar2_table(7) := '31293B0A7D0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D6C207B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A203870783B0A2020626F726465722D626F74746F6D2D72696768742D72';
wwv_flow_api.g_varchar2_table(8) := '61646975733A203870783B0A7D0A6469762E6461746564726F707065722E766974615F736C6174653A6265666F72652C0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D7375626D69742C0A6469762E646174656472';
wwv_flow_api.g_varchar2_table(9) := '6F707065722E766974615F736C617465202E7069636B2D6C672D62202E7069636B2D736C3A6265666F72652C0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D6D2C0A6469762E6461746564726F707065722E766974';
wwv_flow_api.g_varchar2_table(10) := '615F736C617465202E7069636B2D6C672D68207B0A20206261636B67726F756E642D636F6C6F723A20233530356636643B0A7D0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D792E7069636B2D6A756D702C0A6469';
wwv_flow_api.g_varchar2_table(11) := '762E6461746564726F707065722E766974615F736C617465202E7069636B206C69207370616E2C0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D6C672D62202E7069636B2D776B652C0A6469762E6461746564726F';
wwv_flow_api.g_varchar2_table(12) := '707065722E766974615F736C617465202E7069636B2D62746E207B0A2020636F6C6F723A20233530356636643B0A7D0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B65722C0A6469762E6461746564726F707065722E';
wwv_flow_api.g_varchar2_table(13) := '766974615F736C617465202E7069636B2D6C207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B65722C0A6469762E6461746564726F70706572';
wwv_flow_api.g_varchar2_table(14) := '2E766974615F736C617465202E7069636B2D6172772C0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D6C207B0A2020636F6C6F723A20233444344434443B0A7D0A6469762E6461746564726F707065722E76697461';
wwv_flow_api.g_varchar2_table(15) := '5F736C617465202E7069636B2D6D2C0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D6D202E7069636B2D6172772C0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D6C672D682C';
wwv_flow_api.g_varchar2_table(16) := '0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D6C672D62202E7069636B2D736C2C0A6469762E6461746564726F707065722E766974615F736C617465202E7069636B2D7375626D6974207B0A2020636F6C6F723A20';
wwv_flow_api.g_varchar2_table(17) := '234646463B0A7D0A6469762E6461746564726F707065722E766974615F736C6174652E7069636B65722D74696E793A6265666F72652C0A6469762E6461746564726F707065722E766974615F736C6174652E7069636B65722D74696E79202E7069636B2D';
wwv_flow_api.g_varchar2_table(18) := '6D207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A7D0A6469762E6461746564726F707065722E766974615F736C6174652E7069636B65722D74696E79202E7069636B2D6D2C0A6469762E6461746564726F707065722E76697461';
wwv_flow_api.g_varchar2_table(19) := '5F736C6174652E7069636B65722D74696E79202E7069636B2D6D202E7069636B2D617277207B0A2020636F6C6F723A20233444344434443B0A7D0A6469762E6461746564726F707065722E766974615F736C6174652E7069636B65722D6C6B64202E7069';
wwv_flow_api.g_varchar2_table(20) := '636B2D7375626D6974207B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A2020636F6C6F723A20233444344434443B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395082752984574689)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/css/vita_slate.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '40666F6E742D66616365207B0A2020666F6E742D66616D696C793A20226461746564726F70706572223B0A20207372633A2075726C28227372632F6461746564726F707065722E656F7422293B0A20207372633A2075726C28227372632F646174656472';
wwv_flow_api.g_varchar2_table(2) := '6F707065722E656F743F236965666978222920666F726D61742822656D6265646465642D6F70656E7479706522292C2075726C28227372632F6461746564726F707065722E776F6666222920666F726D61742822776F666622292C2075726C2822737263';
wwv_flow_api.g_varchar2_table(3) := '2F6461746564726F707065722E747466222920666F726D61742822747275657479706522292C2075726C28227372632F6461746564726F707065722E737667236461746564726F70706572222920666F726D6174282273766722293B0A2020666F6E742D';
wwv_flow_api.g_varchar2_table(4) := '7765696768743A206E6F726D616C3B0A2020666F6E742D7374796C653A206E6F726D616C3B0A7D0A5B636C6173735E3D227069636B2D692D225D3A6265666F72652C0A5B636C6173732A3D22207069636B2D692D225D3A6265666F7265207B0A2020666F';
wwv_flow_api.g_varchar2_table(5) := '6E742D66616D696C793A20226461746564726F70706572222021696D706F7274616E743B0A2020666F6E742D7374796C653A206E6F726D616C2021696D706F7274616E743B0A2020666F6E742D7765696768743A206E6F726D616C2021696D706F727461';
wwv_flow_api.g_varchar2_table(6) := '6E743B0A2020666F6E742D76617269616E743A206E6F726D616C2021696D706F7274616E743B0A2020746578742D7472616E73666F726D3A206E6F6E652021696D706F7274616E743B0A2020737065616B3A206E6F6E653B0A20206C696E652D68656967';
wwv_flow_api.g_varchar2_table(7) := '68743A20313B0A20202D7765626B69742D666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0A20202D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A20677261797363616C653B0A7D0A2E7069636B2D692D6C6E673A6265';
wwv_flow_api.g_varchar2_table(8) := '666F7265207B0A2020636F6E74656E743A20225C3661223B0A7D0A2E7069636B2D692D6C6B643A6265666F7265207B0A2020636F6E74656E743A20225C3632223B0A7D0A2E7069636B2D692D636B643A6265666F7265207B0A2020636F6E74656E743A20';
wwv_flow_api.g_varchar2_table(9) := '225C3635223B0A7D0A2E7069636B2D692D723A6265666F7265207B0A2020636F6E74656E743A20225C3636223B0A7D0A2E7069636B2D692D6C3A6265666F7265207B0A2020636F6E74656E743A20225C3638223B0A7D0A2E7069636B2D692D6D696E3A62';
wwv_flow_api.g_varchar2_table(10) := '65666F7265207B0A2020636F6E74656E743A20225C3631223B0A7D0A2E7069636B2D692D6578703A6265666F7265207B0A2020636F6E74656E743A20225C3633223B0A7D0A2E7069636B65722D696E707574207B0A2020637572736F723A20746578743B';
wwv_flow_api.g_varchar2_table(11) := '0A7D0A2E7069636B65722D6D6F64616C2D6F7665726C6179207B0A2020706F736974696F6E3A2066697865643B0A2020746F703A20303B0A20206C6566743A20303B0A202077696474683A20313030253B0A20206865696768743A20313030253B0A2020';
wwv_flow_api.g_varchar2_table(12) := '6261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E38293B0A20207A2D696E6465783A20393939383B0A20206F7061636974793A20313B0A20207669736962696C6974793A2076697369626C653B0A20202D7765626B69';
wwv_flow_api.g_varchar2_table(13) := '742D7472616E736974696F6E3A206F70616369747920302E347320656173652C207669736962696C69747920302E347320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A206F70616369747920302E347320656173652C207669736962696C';
wwv_flow_api.g_varchar2_table(14) := '69747920302E347320656173653B0A20202D6D732D7472616E736974696F6E3A206F70616369747920302E347320656173652C207669736962696C69747920302E347320656173653B0A20202D6F2D7472616E736974696F6E3A206F7061636974792030';
wwv_flow_api.g_varchar2_table(15) := '2E347320656173652C207669736962696C69747920302E347320656173653B0A7D0A2E7069636B65722D6D6F64616C2D6F7665726C61792E746F68696465207B0A20206F7061636974793A20303B0A20207669736962696C6974793A2068696464656E3B';
wwv_flow_api.g_varchar2_table(16) := '0A7D0A6469762E6461746564726F70706572207B0A2020706F736974696F6E3A206162736F6C7574653B0A2020746F703A20303B0A20206C6566743A20303B0A20207A2D696E6465783A20393939393B0A20202D7765626B69742D7472616E73666F726D';
wwv_flow_api.g_varchar2_table(17) := '3A207472616E736C61746558282D353025293B0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D353025293B0A20202D6D732D7472616E73666F726D3A207472616E736C61746558282D353025293B0A20202D6F2D7472616E';
wwv_flow_api.g_varchar2_table(18) := '73666F726D3A207472616E736C61746558282D353025293B0A20206C696E652D6865696768743A20313B0A2020666F6E742D66616D696C793A2073616E732D73657269663B0A20202D7765626B69742D626F782D73697A696E673A20626F726465722D62';
wwv_flow_api.g_varchar2_table(19) := '6F783B0A20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A20626F726465722D626F783B0A20202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A20202D6D6F7A2D757365';
wwv_flow_api.g_varchar2_table(20) := '722D73656C6563743A206E6F6E653B0A20202D6D732D757365722D73656C6563743A206E6F6E653B0A20202D6F2D757365722D73656C6563743A206E6F6E653B0A2020757365722D73656C6563743A206E6F6E653B0A20202D7765626B69742D7461702D';
wwv_flow_api.g_varchar2_table(21) := '686967686C696768742D636F6C6F723A207267626128302C20302C20302C2030293B0A20206F7061636974793A20303B0A20207669736962696C6974793A2068696464656E3B0A20206D617267696E2D746F703A202D3870783B0A20207472616E73666F';
wwv_flow_api.g_varchar2_table(22) := '726D2D7374796C653A2070726573657276652D33643B0A20202D7765626B69742D70657273706563746976653A20313030303B0A20202D6D6F7A2D70657273706563746976653A20313030303B0A20202D6D732D70657273706563746976653A20313030';
wwv_flow_api.g_varchar2_table(23) := '303B0A202070657273706563746976653A20313030303B0A20202D7765626B69742D6261636B666163652D7669736962696C6974793A2068696464656E3B0A20202D6D6F7A2D6261636B666163652D7669736962696C6974793A2068696464656E3B0A20';
wwv_flow_api.g_varchar2_table(24) := '202D6D732D6261636B666163652D7669736962696C6974793A2068696464656E3B0A20206261636B666163652D7669736962696C6974793A2068696464656E3B0A7D0A6469762E6461746564726F707065723A6265666F7265207B0A2020636F6E74656E';
wwv_flow_api.g_varchar2_table(25) := '743A2022223B0A2020706F736974696F6E3A206162736F6C7574653B0A202077696474683A20313670783B0A20206865696768743A20313670783B0A2020746F703A202D3870783B0A20206C6566743A203530253B0A20202D7765626B69742D7472616E';
wwv_flow_api.g_varchar2_table(26) := '73666F726D3A207472616E736C61746558282D3530252920726F74617465283435646567293B0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D3530252920726F74617465283435646567293B0A20202D6D732D7472616E73';
wwv_flow_api.g_varchar2_table(27) := '666F726D3A207472616E736C61746558282D3530252920726F74617465283435646567293B0A20202D6F2D7472616E73666F726D3A207472616E736C61746558282D3530252920726F74617465283435646567293B0A2020626F726465722D746F702D6C';
wwv_flow_api.g_varchar2_table(28) := '6566742D7261646975733A203470783B0A7D0A6469762E6461746564726F707065722E7069636B65722D666F637573207B0A20206F7061636974793A20313B0A20207669736962696C6974793A2076697369626C653B0A20206D617267696E2D746F703A';
wwv_flow_api.g_varchar2_table(29) := '203870783B0A7D0A6469762E6461746564726F707065722E7069636B65722D6D6F64616C207B0A2020746F703A2035302521696D706F7274616E743B0A20206C6566743A2035302521696D706F7274616E743B0A20202D7765626B69742D7472616E7366';
wwv_flow_api.g_varchar2_table(30) := '6F726D3A207472616E736C617465282D3530252C202D353025292021696D706F7274616E743B0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D3530252C202D353025292021696D706F7274616E743B0A20202D6D732D747261';
wwv_flow_api.g_varchar2_table(31) := '6E73666F726D3A207472616E736C617465282D3530252C202D353025292021696D706F7274616E743B0A20202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D353025292021696D706F7274616E743B0A2020706F73697469';
wwv_flow_api.g_varchar2_table(32) := '6F6E3A20666978656421696D706F7274616E743B0A20206D617267696E3A203021696D706F7274616E743B0A7D0A6469762E6461746564726F707065722E7069636B65722D6D6F64616C3A6265666F7265207B0A2020646973706C61793A206E6F6E653B';
wwv_flow_api.g_varchar2_table(33) := '0A7D0A6469762E6461746564726F70706572202E7069636B6572207B0A20206F766572666C6F773A2068696464656E3B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C207B0A20206D617267696E3A20303B0A20207061646469';
wwv_flow_api.g_varchar2_table(34) := '6E673A20303B0A20206C6973742D7374796C653A206E6F6E653B0A2020637572736F723A20706F696E7465723B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B207B0A2020706F736974696F6E3A2072656C617469';
wwv_flow_api.g_varchar2_table(35) := '76653B0A20206F766572666C6F773A2068696464656E3B0A20206D61782D6865696768743A2031303070783B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B3A6E74682D6F662D74797065283229207B0A2020626F';
wwv_flow_api.g_varchar2_table(36) := '782D736861646F773A203020317078207267626128302C20302C20302C20302E3036293B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B206C69207B0A2020706F736974696F6E3A206162736F6C7574653B0A2020';
wwv_flow_api.g_varchar2_table(37) := '746F703A20303B0A20206C6566743A20303B0A202077696474683A20313030253B0A20206865696768743A20313030253B0A2020746578742D616C69676E3A2063656E7465723B0A20206F7061636974793A202E353B0A2020646973706C61793A20626C';
wwv_flow_api.g_varchar2_table(38) := '6F636B3B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B206C692E7069636B2D616672207B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465592831303025293B0A20202D6D6F7A2D74';
wwv_flow_api.g_varchar2_table(39) := '72616E73666F726D3A207472616E736C617465592831303025293B0A20202D6D732D7472616E73666F726D3A207472616E736C617465592831303025293B0A20202D6F2D7472616E73666F726D3A207472616E736C617465592831303025293B0A7D0A64';
wwv_flow_api.g_varchar2_table(40) := '69762E6461746564726F70706572202E7069636B657220756C2E7069636B206C692E7069636B2D626672207B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C61746559282D31303025293B0A20202D6D6F7A2D7472616E73666F72';
wwv_flow_api.g_varchar2_table(41) := '6D3A207472616E736C61746559282D31303025293B0A20202D6D732D7472616E73666F726D3A207472616E736C61746559282D31303025293B0A20202D6F2D7472616E73666F726D3A207472616E736C61746559282D31303025293B0A7D0A6469762E64';
wwv_flow_api.g_varchar2_table(42) := '61746564726F70706572202E7069636B657220756C2E7069636B206C692E7069636B2D736C207B0A20206F7061636974793A20313B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465592830293B0A20202D6D6F7A2D747261';
wwv_flow_api.g_varchar2_table(43) := '6E73666F726D3A207472616E736C617465592830293B0A20202D6D732D7472616E73666F726D3A207472616E736C617465592830293B0A20202D6F2D7472616E73666F726D3A207472616E736C617465592830293B0A20207A2D696E6465783A20313B0A';
wwv_flow_api.g_varchar2_table(44) := '7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B206C69207370616E207B0A2020666F6E742D73697A653A20313670783B0A2020706F736974696F6E3A206162736F6C7574653B0A20206C6566743A20303B0A20207769';
wwv_flow_api.g_varchar2_table(45) := '6474683A20313030253B0A20206C696E652D6865696768743A20303B0A2020626F74746F6D3A20323470783B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D617277207B0A2020706F736974696F';
wwv_flow_api.g_varchar2_table(46) := '6E3A206162736F6C7574653B0A2020746F703A20303B0A20206865696768743A20313030253B0A202077696474683A203235253B0A2020666F6E742D73697A653A20313070783B0A2020746578742D616C69676E3A2063656E7465723B0A202064697370';
wwv_flow_api.g_varchar2_table(47) := '6C61793A20626C6F636B3B0A20207A2D696E6465783A2031303B0A2020637572736F723A20706F696E7465723B0A20206261636B67726F756E642D73697A653A203234707820323470783B0A20206261636B67726F756E642D706F736974696F6E3A2063';
wwv_flow_api.g_varchar2_table(48) := '656E7465723B0A20206261636B67726F756E642D7265706561743A206E6F2D7265706561743B0A20206F766572666C6F773A2068696464656E3B0A20206F7061636974793A20303B0A20202D7765626B69742D7472616E73666F726D3A207363616C6528';
wwv_flow_api.g_varchar2_table(49) := '30293B0A20202D6D6F7A2D7472616E73666F726D3A207363616C652830293B0A20202D6D732D7472616E73666F726D3A207363616C652830293B0A20202D6F2D7472616E73666F726D3A207363616C652830293B0A7D0A6469762E6461746564726F7070';
wwv_flow_api.g_varchar2_table(50) := '6572202E7069636B657220756C2E7069636B202E7069636B2D6172772069207B0A20206C696E652D6865696768743A20303B0A2020746F703A203530253B0A2020706F736974696F6E3A2072656C61746976653B0A2020646973706C61793A20626C6F63';
wwv_flow_api.g_varchar2_table(51) := '6B3B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C61746559282D353025293B0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C61746559282D353025293B0A20202D6D732D7472616E73666F726D3A207472616E73';
wwv_flow_api.g_varchar2_table(52) := '6C61746559282D353025293B0A20202D6F2D7472616E73666F726D3A207472616E736C61746559282D353025293B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D';
wwv_flow_api.g_varchar2_table(53) := '73313A686F766572207B0A20206F7061636974793A20313B0A20202D7765626B69742D7472616E73666F726D3A207363616C6528312E32293B0A20202D6D6F7A2D7472616E73666F726D3A207363616C6528312E32293B0A20202D6D732D7472616E7366';
wwv_flow_api.g_varchar2_table(54) := '6F726D3A207363616C6528312E32293B0A20202D6F2D7472616E73666F726D3A207363616C6528312E32293B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D7220';
wwv_flow_api.g_varchar2_table(55) := '7B0A202072696768743A20303B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D722069207B0A202072696768743A20303B0A7D0A6469762E6461746564726F7070';
wwv_flow_api.g_varchar2_table(56) := '6572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D6C207B0A20206C6566743A20303B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E706963';
wwv_flow_api.g_varchar2_table(57) := '6B2D6172772D6C2069207B0A20206C6566743A20303B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D73322E7069636B2D6172772D72207B0A20202D7765626B69';
wwv_flow_api.g_varchar2_table(58) := '742D7472616E73666F726D3A207472616E736C617465582831303025293B0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C617465582831303025293B0A20202D6D732D7472616E73666F726D3A207472616E736C61746558283130302529';
wwv_flow_api.g_varchar2_table(59) := '3B0A20202D6F2D7472616E73666F726D3A207472616E736C617465582831303025293B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D73322E7069636B2D617277';
wwv_flow_api.g_varchar2_table(60) := '2D6C207B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C61746558282D31303025293B0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D31303025293B0A20202D6D732D7472616E73666F726D3A2074';
wwv_flow_api.g_varchar2_table(61) := '72616E736C61746558282D31303025293B0A20202D6F2D7472616E73666F726D3A207472616E736C61746558282D31303025293B0A7D0A406D65646961206F6E6C792073637265656E20616E6420286D61782D77696474683A20343830707829207B0A20';
wwv_flow_api.g_varchar2_table(62) := '206469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D617277207B0A202020202D7765626B69742D7472616E73666F726D3A207363616C652831293B0A202020202D6D6F7A2D7472616E73666F726D3A207363';
wwv_flow_api.g_varchar2_table(63) := '616C652831293B0A202020202D6D732D7472616E73666F726D3A207363616C652831293B0A202020202D6F2D7472616E73666F726D3A207363616C652831293B0A202020206F7061636974793A20302E343B0A20207D0A7D0A6469762E6461746564726F';
wwv_flow_api.g_varchar2_table(64) := '70706572202E7069636B657220756C2E7069636B2E7069636B2D6D2C0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D792C0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B';
wwv_flow_api.g_varchar2_table(65) := '2E7069636B2D6C207B0A20206865696768743A20363070783B0A20206C696E652D6865696768743A20363070783B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D6D207B0A2020666F6E742D73697A';
wwv_flow_api.g_varchar2_table(66) := '653A20333270783B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D79207B0A2020666F6E742D73697A653A20323470783B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E';
wwv_flow_api.g_varchar2_table(67) := '7069636B2E7069636B2D792E7069636B2D6A756D70202E7069636B2D6172772E7069636B2D6172772D73312E7069636B2D6172772D722069207B0A202072696768743A20313670783B0A7D0A6469762E6461746564726F70706572202E7069636B657220';
wwv_flow_api.g_varchar2_table(68) := '756C2E7069636B2E7069636B2D792E7069636B2D6A756D70202E7069636B2D6172772E7069636B2D6172772D73312E7069636B2D6172772D6C2069207B0A20206C6566743A20313670783B0A7D0A6469762E6461746564726F70706572202E7069636B65';
wwv_flow_api.g_varchar2_table(69) := '7220756C2E7069636B2E7069636B2D792E7069636B2D6A756D70202E7069636B2D6172772E7069636B2D6172772D73322E7069636B2D6172772D722C0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D792E';
wwv_flow_api.g_varchar2_table(70) := '7069636B2D6A756D70202E7069636B2D6172772E7069636B2D6172772D73322E7069636B2D6172772D6C207B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465582830293B0A20202D6D6F7A2D7472616E73666F726D3A2074';
wwv_flow_api.g_varchar2_table(71) := '72616E736C617465582830293B0A20202D6D732D7472616E73666F726D3A207472616E736C617465582830293B0A20202D6F2D7472616E73666F726D3A207472616E736C617465582830293B0A7D0A6469762E6461746564726F70706572202E7069636B';
wwv_flow_api.g_varchar2_table(72) := '657220756C2E7069636B2E7069636B2D792E7069636B2D6A756D70202E7069636B2D6172773A686F766572207B0A20202D7765626B69742D7472616E73666F726D3A207363616C6528312E36293B0A20202D6D6F7A2D7472616E73666F726D3A20736361';
wwv_flow_api.g_varchar2_table(73) := '6C6528312E36293B0A20202D6D732D7472616E73666F726D3A207363616C6528312E36293B0A20202D6F2D7472616E73666F726D3A207363616C6528312E36293B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E';
wwv_flow_api.g_varchar2_table(74) := '7069636B2D64207B0A20206865696768743A2031303070783B0A20206C696E652D6865696768743A20383070783B0A2020666F6E742D73697A653A20363470783B0A2020666F6E742D7765696768743A20626F6C643B0A7D0A6469762E6461746564726F';
wwv_flow_api.g_varchar2_table(75) := '70706572202E7069636B657220756C2E7069636B2E7069636B2D6C207B0A2020706F736974696F6E3A206162736F6C7574653B0A2020626F74746F6D3A20303B0A20206C6566743A20303B0A202072696768743A20303B0A20207A2D696E6465783A2031';
wwv_flow_api.g_varchar2_table(76) := '303B0A2020666F6E742D73697A653A20313870783B0A2020666F6E742D7765696768743A20626F6C643B0A20206F7061636974793A20303B0A20207669736962696C6974793A2068696464656E3B0A20202D7765626B69742D7472616E73666F726D3A20';
wwv_flow_api.g_varchar2_table(77) := '7472616E736C617465592833327078293B0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C617465592833327078293B0A20202D6D732D7472616E73666F726D3A207472616E736C617465592833327078293B0A20202D6F2D7472616E7366';
wwv_flow_api.g_varchar2_table(78) := '6F726D3A207472616E736C617465592833327078293B0A20202D7765626B69742D7472616E736974696F6E3A20616C6C20302E347320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A20616C6C20302E347320656173653B0A20202D6D732D';
wwv_flow_api.g_varchar2_table(79) := '7472616E736974696F6E3A20616C6C20302E347320656173653B0A20202D6F2D7472616E736974696F6E3A20616C6C20302E347320656173653B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D6C2E';
wwv_flow_api.g_varchar2_table(80) := '76697369626C65207B0A20206F7061636974793A20313B0A20207669736962696C6974793A2076697369626C653B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465592830293B0A20202D6D6F7A2D7472616E73666F726D3A';
wwv_flow_api.g_varchar2_table(81) := '207472616E736C617465592830293B0A20202D6D732D7472616E73666F726D3A207472616E736C617465592830293B0A20202D6F2D7472616E73666F726D3A207472616E736C617465592830293B0A7D0A6469762E6461746564726F70706572202E7069';
wwv_flow_api.g_varchar2_table(82) := '636B657220756C2E7069636B3A686F766572202E7069636B2D617277207B0A20206F7061636974793A20302E363B0A20202D7765626B69742D7472616E73666F726D3A207363616C652831293B0A20202D6D6F7A2D7472616E73666F726D3A207363616C';
wwv_flow_api.g_varchar2_table(83) := '652831293B0A20202D6D732D7472616E73666F726D3A207363616C652831293B0A20202D6F2D7472616E73666F726D3A207363616C652831293B0A7D0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D643A';
wwv_flow_api.g_varchar2_table(84) := '686F7665722C0A6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D793A686F766572207B0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3032293B0A7D0A646976';
wwv_flow_api.g_varchar2_table(85) := '2E6461746564726F70706572202E7069636B6572202E7069636B2D6C67207B0A20207A2D696E6465783A20313B0A20206D617267696E3A2030206175746F3B0A20206D61782D6865696768743A20303B0A20206F766572666C6F773A2068696464656E3B';
wwv_flow_api.g_varchar2_table(86) := '0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C672E646F776E207B0A2020616E696D6174696F6E3A20646F776E202E387320656173653B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069';
wwv_flow_api.g_varchar2_table(87) := '636B2D6C67202E7069636B2D68207B0A20206F7061636974793A20302E343B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C3A6166746572207B0A2020636F6E74656E743A2022223B0A2020646973706C';
wwv_flow_api.g_varchar2_table(88) := '61793A207461626C653B0A2020636C6561723A20626F74683B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C206C69207B0A2020666C6F61743A206C6566743B0A2020746578742D616C69676E3A206365';
wwv_flow_api.g_varchar2_table(89) := '6E7465723B0A202077696474683A2031342E323835373134323836253B0A20206C696E652D6865696768743A20333670783B0A20206865696768743A20333670783B0A2020666F6E742D73697A653A20313470783B0A7D0A6469762E6461746564726F70';
wwv_flow_api.g_varchar2_table(90) := '706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D68207B0A202070616464696E673A203020313670783B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C67';
wwv_flow_api.g_varchar2_table(91) := '2D62207B0A202070616464696E673A20313670783B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D62206C69207B0A2020637572736F723A20706F696E7465723B0A2020706F7369';
wwv_flow_api.g_varchar2_table(92) := '74696F6E3A2072656C61746976653B0A20207A2D696E6465783A20313B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D62206C693A6265666F7265207B0A2020636F6E74656E743A';
wwv_flow_api.g_varchar2_table(93) := '2022223B0A2020706F736974696F6E3A206162736F6C7574653B0A20207A2D696E6465783A202D313B0A202077696474683A20343870783B0A20206865696768743A20343870783B0A2020626F782D736861646F773A2030203020333270782072676261';
wwv_flow_api.g_varchar2_table(94) := '28302C20302C20302C20302E31293B0A2020626F726465722D7261646975733A20333270783B0A2020746F703A203530253B0A20206C6566743A203530253B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C';
wwv_flow_api.g_varchar2_table(95) := '202D35302529207363616C652830293B0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207363616C652830293B0A20202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C20';
wwv_flow_api.g_varchar2_table(96) := '2D35302529207363616C652830293B0A20202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207363616C652830293B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C672075';
wwv_flow_api.g_varchar2_table(97) := '6C2E7069636B2D6C672D62206C692E7069636B2D763A686F766572207B0A2020746578742D6465636F726174696F6E3A20756E6465726C696E653B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069';
wwv_flow_api.g_varchar2_table(98) := '636B2D6C672D62206C692E7069636B2D6C6B3A6166746572207B0A2020636F6E74656E743A2022223B0A2020706F736974696F6E3A206162736F6C7574653B0A2020746F703A203530253B0A20206C6566743A203470783B0A202072696768743A203470';
wwv_flow_api.g_varchar2_table(99) := '783B0A20206865696768743A203170783B0A20206261636B67726F756E643A207267626128302C20302C20302C20302E32293B0A20202D7765626B69742D7472616E73666F726D3A20726F74617465283435646567293B0A20202D6D6F7A2D7472616E73';
wwv_flow_api.g_varchar2_table(100) := '666F726D3A20726F74617465283435646567293B0A20202D6D732D7472616E73666F726D3A20726F74617465283435646567293B0A20202D6F2D7472616E73666F726D3A20726F74617465283435646567293B0A7D0A6469762E6461746564726F707065';
wwv_flow_api.g_varchar2_table(101) := '72202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D62206C692E7069636B2D736C207B0A2020666F6E742D73697A653A20323470783B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C672075';
wwv_flow_api.g_varchar2_table(102) := '6C2E7069636B2D6C672D62206C692E7069636B2D736C3A6265666F7265207B0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207363616C652831293B0A20202D6D6F7A2D7472616E73666F72';
wwv_flow_api.g_varchar2_table(103) := '6D3A207472616E736C617465282D3530252C202D35302529207363616C652831293B0A20202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207363616C652831293B0A20202D6F2D7472616E73666F726D3A20';
wwv_flow_api.g_varchar2_table(104) := '7472616E736C617465282D3530252C202D35302529207363616C652831293B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73207B0A20206D617267696E3A202D3170783B0A2020706F736974696F6E3A2072';
wwv_flow_api.g_varchar2_table(105) := '656C61746976653B0A20207A2D696E6465783A20323B0A20206865696768743A20353670783B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E7320646976207B0A2020637572736F723A20706F696E7465723B';
wwv_flow_api.g_varchar2_table(106) := '0A20206C696E652D6865696768743A20303B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D7375626D6974207B0A20206D617267696E3A2030206175746F3B0A202077696474683A203536';
wwv_flow_api.g_varchar2_table(107) := '70783B0A20206865696768743A20353670783B0A20206C696E652D6865696768743A20363470783B0A2020626F726465722D7261646975733A20353670783B0A2020666F6E742D73697A653A20323470783B0A2020637572736F723A20706F696E746572';
wwv_flow_api.g_varchar2_table(108) := '3B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A20303B0A2020626F726465722D626F74746F6D2D72696768742D7261646975733A20303B0A2020746578742D616C69676E3A2063656E7465723B0A2020706F736974696F6E3A';
wwv_flow_api.g_varchar2_table(109) := '2072656C61746976653B0A2020746F703A20303B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D7375626D69743A6166746572207B0A2020666F6E742D66616D696C793A20226461746564';
wwv_flow_api.g_varchar2_table(110) := '726F70706572222021696D706F7274616E743B0A2020666F6E742D7374796C653A206E6F726D616C2021696D706F7274616E743B0A2020666F6E742D7765696768743A206E6F726D616C2021696D706F7274616E743B0A2020666F6E742D76617269616E';
wwv_flow_api.g_varchar2_table(111) := '743A206E6F726D616C2021696D706F7274616E743B0A2020746578742D7472616E73666F726D3A206E6F6E652021696D706F7274616E743B0A2020737065616B3A206E6F6E653B0A20206C696E652D6865696768743A20313B0A20202D7765626B69742D';
wwv_flow_api.g_varchar2_table(112) := '666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0A20202D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A20677261797363616C653B0A20206C696E652D6865696768743A20363070783B0A2020636F6E74656E743A2022';
wwv_flow_api.g_varchar2_table(113) := '5C3635223B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D7375626D69743A686F766572207B0A2020746F703A203470783B0A2020626F782D736861646F773A2030203020302031367078';
wwv_flow_api.g_varchar2_table(114) := '207267626128302C20302C20302C20302E3034292C20302030203020387078207267626128302C20302C20302C20302E3034293B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E20';
wwv_flow_api.g_varchar2_table(115) := '7B0A2020706F736974696F6E3A206162736F6C7574653B0A202077696474683A20333270783B0A20206865696768743A20333270783B0A2020626F74746F6D3A20303B0A2020746578742D616C69676E3A2063656E7465723B0A20206C696E652D686569';
wwv_flow_api.g_varchar2_table(116) := '6768743A20333870783B0A2020666F6E742D73697A653A20313670783B0A20206D617267696E3A203870783B0A2020626F726465722D7261646975733A203470783B0A20206261636B67726F756E643A207267626128302C20302C20302C20302E303329';
wwv_flow_api.g_varchar2_table(117) := '3B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E3A686F766572207B0A20206261636B67726F756E643A20234646463B0A20202D7765626B69742D626F782D736861646F773A2030';
wwv_flow_api.g_varchar2_table(118) := '20302033327078207267626128302C20302C20302C20302E31293B0A20202D6D6F7A2D626F782D736861646F773A203020302033327078207267626128302C20302C20302C20302E31293B0A2020626F782D736861646F773A2030203020333270782072';
wwv_flow_api.g_varchar2_table(119) := '67626128302C20302C20302C20302E31293B0A20202D7765626B69742D7472616E73666F726D3A207363616C6528312E32293B0A20202D6D6F7A2D7472616E73666F726D3A207363616C6528312E32293B0A20202D6D732D7472616E73666F726D3A2073';
wwv_flow_api.g_varchar2_table(120) := '63616C6528312E32293B0A20202D6F2D7472616E73666F726D3A207363616C6528312E32293B0A7D0A6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E3A6166746572207B0A2020666F6E74';
wwv_flow_api.g_varchar2_table(121) := '2D66616D696C793A20226461746564726F70706572222021696D706F7274616E743B0A2020666F6E742D7374796C653A206E6F726D616C2021696D706F7274616E743B0A2020666F6E742D7765696768743A206E6F726D616C2021696D706F7274616E74';
wwv_flow_api.g_varchar2_table(122) := '3B0A2020666F6E742D76617269616E743A206E6F726D616C2021696D706F7274616E743B0A2020746578742D7472616E73666F726D3A206E6F6E652021696D706F7274616E743B0A2020737065616B3A206E6F6E653B0A20206C696E652D686569676874';
wwv_flow_api.g_varchar2_table(123) := '3A20313B0A20202D7765626B69742D666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0A20202D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A20677261797363616C653B0A7D0A6469762E6461746564726F7070657220';
wwv_flow_api.g_varchar2_table(124) := '2E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E2E7069636B2D62746E2D737A207B0A202072696768743A20303B0A20207472616E73666F726D2D6F726967696E3A20726967687420626F74746F6D3B0A7D0A6469762E6461746564';
wwv_flow_api.g_varchar2_table(125) := '726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E2E7069636B2D62746E2D737A3A6166746572207B0A2020636F6E74656E743A20225C3633223B0A7D0A6469762E6461746564726F70706572202E7069636B657220';
wwv_flow_api.g_varchar2_table(126) := '2E7069636B2D62746E73202E7069636B2D62746E2E7069636B2D62746E2D6C6E67207B0A20206C6566743A20303B0A20207472616E73666F726D2D6F726967696E3A206C65667420626F74746F6D3B0A7D0A6469762E6461746564726F70706572202E70';
wwv_flow_api.g_varchar2_table(127) := '69636B6572202E7069636B2D62746E73202E7069636B2D62746E2E7069636B2D62746E2D6C6E673A6166746572207B0A2020636F6E74656E743A20225C3661223B0A7D0A6469762E6461746564726F707065722E7069636B65722D6C67207B0A20207769';
wwv_flow_api.g_varchar2_table(128) := '6474683A20333030707821696D706F7274616E743B0A7D0A6469762E6461746564726F707065722E7069636B65722D6C6720756C2E7069636B2E7069636B2D64207B0A20202D7765626B69742D7472616E73666F726D3A207363616C652830293B0A2020';
wwv_flow_api.g_varchar2_table(129) := '2D6D6F7A2D7472616E73666F726D3A207363616C652830293B0A20202D6D732D7472616E73666F726D3A207363616C652830293B0A20202D6F2D7472616E73666F726D3A207363616C652830293B0A20206D61782D6865696768743A203021696D706F72';
wwv_flow_api.g_varchar2_table(130) := '74616E743B0A7D0A6469762E6461746564726F707065722E7069636B65722D6C67202E7069636B2D6C67207B0A20206D61782D6865696768743A2033323070783B0A7D0A6469762E6461746564726F707065722E7069636B65722D6C67202E7069636B2D';
wwv_flow_api.g_varchar2_table(131) := '62746E73202E7069636B2D62746E2E7069636B2D62746E2D737A3A6166746572207B0A2020636F6E74656E743A20225C3631223B0A7D0A406D65646961206F6E6C792073637265656E20616E6420286D61782D77696474683A20343830707829207B0A20';
wwv_flow_api.g_varchar2_table(132) := '206469762E6461746564726F707065722E7069636B65722D6C67207B0A20202020706F736974696F6E3A2066697865643B0A20202020746F703A2035302521696D706F7274616E743B0A202020206C6566743A2035302521696D706F7274616E743B0A20';
wwv_flow_api.g_varchar2_table(133) := '2020202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C202D353025293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D3530252C202D353025293B0A202020202D6D732D7472616E';
wwv_flow_api.g_varchar2_table(134) := '73666F726D3A207472616E736C617465282D3530252C202D353025293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D353025293B0A202020206D617267696E3A20303B0A20207D0A20206469762E64617465';
wwv_flow_api.g_varchar2_table(135) := '64726F707065722E7069636B65722D6C673A6265666F7265207B0A20202020646973706C61793A206E6F6E653B0A20207D0A7D0A402D6D6F7A2D6B65796672616D6573207069636B65725F6C6F636B6564207B0A202030252C0A202031303025207B0A20';
wwv_flow_api.g_varchar2_table(136) := '2020202D7765626B69742D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D35302529207472';
wwv_flow_api.g_varchar2_table(137) := '616E736C617465336428302C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E';
wwv_flow_api.g_varchar2_table(138) := '736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A20207D0A20203130252C0A20203330252C0A20203530252C0A20203730252C0A2020393025207B0A202020202D7765626B69742D7472616E73666F726D3A207472';
wwv_flow_api.g_varchar2_table(139) := '616E736C61746558282D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364282D3270782C20302C203029';
wwv_flow_api.g_varchar2_table(140) := '3B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746558282D35302529207472';
wwv_flow_api.g_varchar2_table(141) := '616E736C6174653364282D3270782C20302C2030293B0A20207D0A20203230252C0A20203430252C0A20203630252C0A2020383025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E';
wwv_flow_api.g_varchar2_table(142) := '736C6174653364283270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D732D7472616E73666F726D3A20';
wwv_flow_api.g_varchar2_table(143) := '7472616E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A';
wwv_flow_api.g_varchar2_table(144) := '20207D0A7D0A402D7765626B69742D6B65796672616D6573207069636B65725F6C6F636B6564207B0A202030252C0A202031303025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E';
wwv_flow_api.g_varchar2_table(145) := '736C617465336428302C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E';
wwv_flow_api.g_varchar2_table(146) := '736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A20207D0A20203130';
wwv_flow_api.g_varchar2_table(147) := '252C0A20203330252C0A20203530252C0A20203730252C0A2020393025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020';
wwv_flow_api.g_varchar2_table(148) := '202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E73';
wwv_flow_api.g_varchar2_table(149) := '6C6174653364282D3270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364282D3270782C20302C2030293B0A20207D0A20203230252C0A20203430252C0A2020';
wwv_flow_api.g_varchar2_table(150) := '3630252C0A2020383025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A20747261';
wwv_flow_api.g_varchar2_table(151) := '6E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A2020';
wwv_flow_api.g_varchar2_table(152) := '20202D6F2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A20207D0A7D0A406B65796672616D6573207069636B65725F6C6F636B6564207B0A202030252C0A20203130';
wwv_flow_api.g_varchar2_table(153) := '3025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D35';
wwv_flow_api.g_varchar2_table(154) := '302529207472616E736C617465336428302C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6F2D7472616E73666F726D';
wwv_flow_api.g_varchar2_table(155) := '3A207472616E736C61746558282D35302529207472616E736C617465336428302C20302C2030293B0A20207D0A20203130252C0A20203330252C0A20203530252C0A20203730252C0A2020393025207B0A202020202D7765626B69742D7472616E73666F';
wwv_flow_api.g_varchar2_table(156) := '726D3A207472616E736C61746558282D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364282D3270782C';
wwv_flow_api.g_varchar2_table(157) := '20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746558282D35';
wwv_flow_api.g_varchar2_table(158) := '302529207472616E736C6174653364282D3270782C20302C2030293B0A20207D0A20203230252C0A20203430252C0A20203630252C0A2020383025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C61746558282D353025';
wwv_flow_api.g_varchar2_table(159) := '29207472616E736C6174653364283270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D732D7472616E73';
wwv_flow_api.g_varchar2_table(160) := '666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C61746558282D35302529207472616E736C6174653364283270782C2030';
wwv_flow_api.g_varchar2_table(161) := '2C2030293B0A20207D0A7D0A402D6D6F7A2D6B65796672616D6573207069636B65725F6C6F636B65645F6C617267655F6D6F62696C65207B0A202030252C0A202031303025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E73';
wwv_flow_api.g_varchar2_table(162) := '6C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030';
wwv_flow_api.g_varchar2_table(163) := '293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C20';
wwv_flow_api.g_varchar2_table(164) := '2D35302529207472616E736C617465336428302C20302C2030293B0A20207D0A20203130252C0A20203330252C0A20203530252C0A20203730252C0A2020393025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465';
wwv_flow_api.g_varchar2_table(165) := '282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C';
wwv_flow_api.g_varchar2_table(166) := '2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465282D';
wwv_flow_api.g_varchar2_table(167) := '3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A20207D0A20203230252C0A20203430252C0A20203630252C0A2020383025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C6174';
wwv_flow_api.g_varchar2_table(168) := '65282D3530252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364283270782C20302C20';
wwv_flow_api.g_varchar2_table(169) := '30293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465282D3530';
wwv_flow_api.g_varchar2_table(170) := '252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A20207D0A7D0A402D7765626B69742D6B65796672616D6573207069636B65725F6C6F636B65645F6C617267655F6D6F62696C65207B0A202030252C0A20203130302520';
wwv_flow_api.g_varchar2_table(171) := '7B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D';
wwv_flow_api.g_varchar2_table(172) := '3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A20202020';
wwv_flow_api.g_varchar2_table(173) := '2D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A20207D0A20203130252C0A20203330252C0A20203530252C0A20203730252C0A2020393025207B0A2020';
wwv_flow_api.g_varchar2_table(174) := '20202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D35';
wwv_flow_api.g_varchar2_table(175) := '30252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B';
wwv_flow_api.g_varchar2_table(176) := '0A202020202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A20207D0A20203230252C0A20203430252C0A20203630252C0A2020383025207B0A20';
wwv_flow_api.g_varchar2_table(177) := '2020202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D6F7A2D7472616E73666F726D3A207472616E736C617465282D35';
wwv_flow_api.g_varchar2_table(178) := '30252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A20';
wwv_flow_api.g_varchar2_table(179) := '2020202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A20207D0A7D0A406B65796672616D6573207069636B65725F6C6F636B65645F6C617267655F';
wwv_flow_api.g_varchar2_table(180) := '6D6F62696C65207B0A202030252C0A202031303025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6D6F7A2D';
wwv_flow_api.g_varchar2_table(181) := '7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E';
wwv_flow_api.g_varchar2_table(182) := '736C617465336428302C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C617465336428302C20302C2030293B0A20207D0A20203130252C0A20203330252C0A2020';
wwv_flow_api.g_varchar2_table(183) := '3530252C0A20203730252C0A2020393025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6D6F7A2D74';
wwv_flow_api.g_varchar2_table(184) := '72616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472';
wwv_flow_api.g_varchar2_table(185) := '616E736C6174653364282D3270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364282D3270782C20302C2030293B0A20207D0A20203230252C0A20';
wwv_flow_api.g_varchar2_table(186) := '203430252C0A20203630252C0A2020383025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D6F7A2D74';
wwv_flow_api.g_varchar2_table(187) := '72616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A202020202D6D732D7472616E73666F726D3A207472616E736C617465282D3530252C202D3530252920747261';
wwv_flow_api.g_varchar2_table(188) := '6E736C6174653364283270782C20302C2030293B0A202020202D6F2D7472616E73666F726D3A207472616E736C617465282D3530252C202D35302529207472616E736C6174653364283270782C20302C2030293B0A20207D0A7D0A6469762E6461746564';
wwv_flow_api.g_varchar2_table(189) := '726F707065722E7069636B65722D726D626C207B0A20202D7765626B69742D616E696D6174696F6E3A207069636B65725F6C6F636B656420302E347320656173653B0A20202D6D6F7A2D616E696D6174696F6E3A207069636B65725F6C6F636B65642030';
wwv_flow_api.g_varchar2_table(190) := '2E347320656173653B0A2020616E696D6174696F6E3A207069636B65725F6C6F636B656420302E347320656173653B0A7D0A406D65646961206F6E6C792073637265656E20616E6420286D61782D77696474683A20343830707829207B0A20206469762E';
wwv_flow_api.g_varchar2_table(191) := '6461746564726F707065722E7069636B65722D726D626C2E7069636B65722D6C67207B0A202020202D7765626B69742D616E696D6174696F6E3A207069636B65725F6C6F636B65645F6C617267655F6D6F62696C6520302E347320656173653B0A202020';
wwv_flow_api.g_varchar2_table(192) := '202D6D6F7A2D616E696D6174696F6E3A207069636B65725F6C6F636B65645F6C617267655F6D6F62696C6520302E347320656173653B0A20202020616E696D6174696F6E3A207069636B65725F6C6F636B65645F6C617267655F6D6F62696C6520302E34';
wwv_flow_api.g_varchar2_table(193) := '7320656173653B0A20207D0A7D0A6469762E6461746564726F707065722E7069636B65722D6C6B64202E7069636B2D7375626D6974207B0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3034292021696D70';
wwv_flow_api.g_varchar2_table(194) := '6F7274616E743B0A2020636F6C6F723A207267626128302C20302C20302C20302E32292021696D706F7274616E743B0A7D0A6469762E6461746564726F707065722E7069636B65722D6C6B64202E7069636B2D7375626D69743A686F766572207B0A2020';
wwv_flow_api.g_varchar2_table(195) := '2D7765626B69742D626F782D736861646F773A206E6F6E652021696D706F7274616E743B0A20202D6D6F7A2D626F782D736861646F773A206E6F6E652021696D706F7274616E743B0A2020626F782D736861646F773A206E6F6E652021696D706F727461';
wwv_flow_api.g_varchar2_table(196) := '6E743B0A7D0A6469762E6461746564726F707065722E7069636B65722D6C6B64202E7069636B2D7375626D69743A6166746572207B0A2020636F6E74656E743A20225C3632222021696D706F7274616E743B0A7D0A6469762E6461746564726F70706572';
wwv_flow_api.g_varchar2_table(197) := '2E7069636B65722D667873207B0A20202D7765626B69742D7472616E736974696F6E3A20776964746820302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337292C206F70616369747920302E327320656173652C';
wwv_flow_api.g_varchar2_table(198) := '207669736962696C69747920302E327320656173652C206D617267696E20302E327320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A20776964746820302E38732063756269632D62657A69657228312C202D302E35352C20302E322C2031';
wwv_flow_api.g_varchar2_table(199) := '2E3337292C206F70616369747920302E327320656173652C207669736962696C69747920302E327320656173652C206D617267696E20302E327320656173653B0A20202D6D732D7472616E736974696F6E3A20776964746820302E38732063756269632D';
wwv_flow_api.g_varchar2_table(200) := '62657A69657228312C202D302E35352C20302E322C20312E3337292C206F70616369747920302E327320656173652C207669736962696C69747920302E327320656173652C206D617267696E20302E327320656173653B0A20202D6F2D7472616E736974';
wwv_flow_api.g_varchar2_table(201) := '696F6E3A20776964746820302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337292C206F70616369747920302E327320656173652C207669736962696C69747920302E327320656173652C206D617267696E2030';
wwv_flow_api.g_varchar2_table(202) := '2E327320656173653B0A7D0A6469762E6461746564726F707065722E7069636B65722D66787320756C2E7069636B2E7069636B2D64207B0A20202D7765626B69742D7472616E736974696F6E3A20746F7020302E38732063756269632D62657A69657228';
wwv_flow_api.g_varchar2_table(203) := '312C202D302E35352C20302E322C20312E3337292C207472616E73666F726D20302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337292C206D61782D68656967687420302E38732063756269632D62657A696572';
wwv_flow_api.g_varchar2_table(204) := '28312C202D302E35352C20302E322C20312E3337292C206261636B67726F756E642D636F6C6F7220302E347320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A20746F7020302E38732063756269632D62657A69657228312C202D302E3535';
wwv_flow_api.g_varchar2_table(205) := '2C20302E322C20312E3337292C207472616E73666F726D20302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337292C206D61782D68656967687420302E38732063756269632D62657A69657228312C202D302E35';
wwv_flow_api.g_varchar2_table(206) := '352C20302E322C20312E3337292C206261636B67726F756E642D636F6C6F7220302E347320656173653B0A20202D6D732D7472616E736974696F6E3A20746F7020302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E';
wwv_flow_api.g_varchar2_table(207) := '3337292C207472616E73666F726D20302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337292C206D61782D68656967687420302E38732063756269632D62657A69657228312C202D302E35352C20302E322C2031';
wwv_flow_api.g_varchar2_table(208) := '2E3337292C206261636B67726F756E642D636F6C6F7220302E347320656173653B0A20202D6F2D7472616E736974696F6E3A20746F7020302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337292C207472616E73';
wwv_flow_api.g_varchar2_table(209) := '666F726D20302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337292C206D61782D68656967687420302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337292C206261636B';
wwv_flow_api.g_varchar2_table(210) := '67726F756E642D636F6C6F7220302E347320656173653B0A7D0A6469762E6461746564726F707065722E7069636B65722D66787320756C2E7069636B2E7069636B2D79207B0A20202D7765626B69742D7472616E736974696F6E3A206261636B67726F75';
wwv_flow_api.g_varchar2_table(211) := '6E642D636F6C6F7220302E347320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A206261636B67726F756E642D636F6C6F7220302E347320656173653B0A20202D6D732D7472616E736974696F6E3A206261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(212) := '7220302E347320656173653B0A20202D6F2D7472616E736974696F6E3A206261636B67726F756E642D636F6C6F7220302E347320656173653B0A7D0A6469762E6461746564726F707065722E7069636B65722D66787320756C2E7069636B206C69207B0A';
wwv_flow_api.g_varchar2_table(213) := '20202D7765626B69742D7472616E736974696F6E3A207472616E73666F726D20302E347320656173652C206F70616369747920302E347320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A207472616E73666F726D20302E34732065617365';
wwv_flow_api.g_varchar2_table(214) := '2C206F70616369747920302E347320656173653B0A20202D6D732D7472616E736974696F6E3A207472616E73666F726D20302E347320656173652C206F70616369747920302E347320656173653B0A20202D6F2D7472616E736974696F6E3A207472616E';
wwv_flow_api.g_varchar2_table(215) := '73666F726D20302E347320656173652C206F70616369747920302E347320656173653B0A7D0A6469762E6461746564726F707065722E7069636B65722D66787320756C2E7069636B202E7069636B2D617277207B0A20202D7765626B69742D7472616E73';
wwv_flow_api.g_varchar2_table(216) := '6974696F6E3A207472616E73666F726D20302E327320656173652C206F70616369747920302E327320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A207472616E73666F726D20302E327320656173652C206F70616369747920302E327320';
wwv_flow_api.g_varchar2_table(217) := '656173653B0A20202D6D732D7472616E736974696F6E3A207472616E73666F726D20302E327320656173652C206F70616369747920302E327320656173653B0A20202D6F2D7472616E736974696F6E3A207472616E73666F726D20302E32732065617365';
wwv_flow_api.g_varchar2_table(218) := '2C206F70616369747920302E327320656173653B0A7D0A6469762E6461746564726F707065722E7069636B65722D66787320756C2E7069636B202E7069636B2D6172772069207B0A20202D7765626B69742D7472616E736974696F6E3A20726967687420';
wwv_flow_api.g_varchar2_table(219) := '302E327320656173652C206C65667420302E327320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A20726967687420302E327320656173652C206C65667420302E327320656173653B0A20202D6D732D7472616E736974696F6E3A20726967';
wwv_flow_api.g_varchar2_table(220) := '687420302E327320656173652C206C65667420302E327320656173653B0A20202D6F2D7472616E736974696F6E3A20726967687420302E327320656173652C206C65667420302E327320656173653B0A7D0A6469762E6461746564726F707065722E7069';
wwv_flow_api.g_varchar2_table(221) := '636B65722D667873202E7069636B2D6C67207B0A20202D7765626B69742D7472616E736974696F6E3A206D61782D68656967687420302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337293B0A20202D6D6F7A2D';
wwv_flow_api.g_varchar2_table(222) := '7472616E736974696F6E3A206D61782D68656967687420302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337293B0A20202D6D732D7472616E736974696F6E3A206D61782D68656967687420302E387320637562';
wwv_flow_api.g_varchar2_table(223) := '69632D62657A69657228312C202D302E35352C20302E322C20312E3337293B0A20202D6F2D7472616E736974696F6E3A206D61782D68656967687420302E38732063756269632D62657A69657228312C202D302E35352C20302E322C20312E3337293B0A';
wwv_flow_api.g_varchar2_table(224) := '7D0A6469762E6461746564726F707065722E7069636B65722D667873202E7069636B2D6C67202E7069636B2D6C672D62206C693A6265666F7265207B0A20202D7765626B69742D7472616E736974696F6E3A207472616E73666F726D20302E3273206561';
wwv_flow_api.g_varchar2_table(225) := '73653B0A20202D6D6F7A2D7472616E736974696F6E3A207472616E73666F726D20302E327320656173653B0A20202D6D732D7472616E736974696F6E3A207472616E73666F726D20302E327320656173653B0A20202D6F2D7472616E736974696F6E3A20';
wwv_flow_api.g_varchar2_table(226) := '7472616E73666F726D20302E327320656173653B0A7D0A6469762E6461746564726F707065722E7069636B65722D667873202E7069636B2D62746E73202E7069636B2D7375626D6974207B0A20202D7765626B69742D7472616E736974696F6E3A20746F';
wwv_flow_api.g_varchar2_table(227) := '7020302E327320656173652C20626F782D736861646F7720302E347320656173652C206261636B67726F756E642D636F6C6F7220302E347320656173653B0A20202D6D6F7A2D7472616E736974696F6E3A20746F7020302E327320656173652C20626F78';
wwv_flow_api.g_varchar2_table(228) := '2D736861646F7720302E347320656173652C206261636B67726F756E642D636F6C6F7220302E347320656173653B0A20202D6D732D7472616E736974696F6E3A20746F7020302E327320656173652C20626F782D736861646F7720302E34732065617365';
wwv_flow_api.g_varchar2_table(229) := '2C206261636B67726F756E642D636F6C6F7220302E347320656173653B0A20202D6F2D7472616E736974696F6E3A20746F7020302E327320656173652C20626F782D736861646F7720302E347320656173652C206261636B67726F756E642D636F6C6F72';
wwv_flow_api.g_varchar2_table(230) := '20302E347320656173653B0A7D0A6469762E6461746564726F707065722E7069636B65722D667873202E7069636B2D62746E73202E7069636B2D62746E207B0A20202D7765626B69742D7472616E736974696F6E3A20616C6C20302E327320656173653B';
wwv_flow_api.g_varchar2_table(231) := '0A20202D6D6F7A2D7472616E736974696F6E3A20616C6C20302E327320656173653B0A20202D6D732D7472616E736974696F6E3A20616C6C20302E327320656173653B0A20202D6F2D7472616E736974696F6E3A20616C6C20302E327320656173653B0A';
wwv_flow_api.g_varchar2_table(232) := '7D0A406D65646961206F6E6C792073637265656E20616E6420286D61782D77696474683A20343830707829207B0A20206469762E6461746564726F707065722E7069636B65722D667873207B0A202020202D7765626B69742D7472616E736974696F6E3A';
wwv_flow_api.g_varchar2_table(233) := '206F70616369747920302E327320656173652C207669736962696C69747920302E327320656173652C206D617267696E20302E327320656173653B0A202020202D6D6F7A2D7472616E736974696F6E3A206F70616369747920302E327320656173652C20';
wwv_flow_api.g_varchar2_table(234) := '7669736962696C69747920302E327320656173652C206D617267696E20302E327320656173653B0A202020202D6D732D7472616E736974696F6E3A206F70616369747920302E327320656173652C207669736962696C69747920302E327320656173652C';
wwv_flow_api.g_varchar2_table(235) := '206D617267696E20302E327320656173653B0A202020202D6F2D7472616E736974696F6E3A206F70616369747920302E327320656173652C207669736962696C69747920302E327320656173652C206D617267696E20302E327320656173653B0A20207D';
wwv_flow_api.g_varchar2_table(236) := '0A20206469762E6461746564726F707065722E7069636B65722D66787320756C2E7069636B2E7069636B2D642C0A20206469762E6461746564726F707065722E7069636B65722D667873202E7069636B2D6C67207B0A202020202D7765626B69742D7472';
wwv_flow_api.g_varchar2_table(237) := '616E736974696F6E3A206E6F6E653B0A202020202D6D6F7A2D7472616E736974696F6E3A206E6F6E653B0A202020202D6D732D7472616E736974696F6E3A206E6F6E653B0A202020202D6F2D7472616E736974696F6E3A206E6F6E653B0A20207D0A7D0A';
wwv_flow_api.g_varchar2_table(238) := '6469762E6461746564726F707065722E76616E696C6C61207B0A2020626F726465722D7261646975733A203670783B0A202077696474683A2031383070783B0A7D0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B6572207B0A';
wwv_flow_api.g_varchar2_table(239) := '2020626F726465722D7261646975733A203670783B0A2020626F782D736861646F773A2030203020333270782030207267626128302C20302C20302C20302E31293B0A7D0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C';
wwv_flow_api.g_varchar2_table(240) := '207B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A203670783B0A2020626F726465722D626F74746F6D2D72696768742D7261646975733A203670783B0A7D0A6469762E6461746564726F707065722E76616E696C6C613A6265';
wwv_flow_api.g_varchar2_table(241) := '666F72652C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D7375626D69742C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C672D62202E7069636B2D736C3A6265666F72652C0A6469762E';
wwv_flow_api.g_varchar2_table(242) := '6461746564726F707065722E76616E696C6C61202E7069636B2D6D2C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C672D68207B0A20206261636B67726F756E642D636F6C6F723A20236665616339323B0A7D0A646976';
wwv_flow_api.g_varchar2_table(243) := '2E6461746564726F707065722E76616E696C6C61202E7069636B2D792E7069636B2D6A756D702C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B206C69207370616E2C0A6469762E6461746564726F707065722E76616E696C';
wwv_flow_api.g_varchar2_table(244) := '6C61202E7069636B2D6C672D62202E7069636B2D776B652C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D62746E207B0A2020636F6C6F723A20236665616339323B0A7D0A6469762E6461746564726F707065722E76616E';
wwv_flow_api.g_varchar2_table(245) := '696C6C61202E7069636B65722C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C207B0A20206261636B67726F756E642D636F6C6F723A20236666666666663B0A7D0A6469762E6461746564726F707065722E76616E696C';
wwv_flow_api.g_varchar2_table(246) := '6C61202E7069636B65722C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6172772C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C207B0A2020636F6C6F723A20233965643764623B0A7D';
wwv_flow_api.g_varchar2_table(247) := '0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6D2C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6D202E7069636B2D6172772C0A6469762E6461746564726F707065722E76616E696C6C61';
wwv_flow_api.g_varchar2_table(248) := '202E7069636B2D6C672D682C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C672D62202E7069636B2D736C2C0A6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D7375626D6974207B0A202063';
wwv_flow_api.g_varchar2_table(249) := '6F6C6F723A20236661663766343B0A7D0A6469762E6461746564726F707065722E76616E696C6C612E7069636B65722D74696E793A6265666F72652C0A6469762E6461746564726F707065722E76616E696C6C612E7069636B65722D74696E79202E7069';
wwv_flow_api.g_varchar2_table(250) := '636B2D6D207B0A20206261636B67726F756E642D636F6C6F723A20236666666666663B0A7D0A6469762E6461746564726F707065722E76616E696C6C612E7069636B65722D74696E79202E7069636B2D6D2C0A6469762E6461746564726F707065722E76';
wwv_flow_api.g_varchar2_table(251) := '616E696C6C612E7069636B65722D74696E79202E7069636B2D6D202E7069636B2D617277207B0A2020636F6C6F723A20233965643764623B0A7D0A6469762E6461746564726F707065722E6C656166207B0A2020626F726465722D7261646975733A2036';
wwv_flow_api.g_varchar2_table(252) := '70783B0A202077696474683A2031383070783B0A7D0A6469762E6461746564726F707065722E6C656166202E7069636B6572207B0A2020626F726465722D7261646975733A203670783B0A2020626F782D736861646F773A203020302033327078203020';
wwv_flow_api.g_varchar2_table(253) := '7267626128302C20302C20302C20302E31293B0A7D0A6469762E6461746564726F707065722E6C656166202E7069636B2D6C207B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A203670783B0A2020626F726465722D626F7474';
wwv_flow_api.g_varchar2_table(254) := '6F6D2D72696768742D7261646975733A203670783B0A7D0A6469762E6461746564726F707065722E6C6561663A6265666F72652C0A6469762E6461746564726F707065722E6C656166202E7069636B2D7375626D69742C0A6469762E6461746564726F70';
wwv_flow_api.g_varchar2_table(255) := '7065722E6C656166202E7069636B2D6C672D62202E7069636B2D736C3A6265666F72652C0A6469762E6461746564726F707065722E6C656166202E7069636B2D6D2C0A6469762E6461746564726F707065722E6C656166202E7069636B2D6C672D68207B';
wwv_flow_api.g_varchar2_table(256) := '0A20206261636B67726F756E642D636F6C6F723A20233165636438303B0A7D0A6469762E6461746564726F707065722E6C656166202E7069636B2D792E7069636B2D6A756D702C0A6469762E6461746564726F707065722E6C656166202E7069636B206C';
wwv_flow_api.g_varchar2_table(257) := '69207370616E2C0A6469762E6461746564726F707065722E6C656166202E7069636B2D6C672D62202E7069636B2D776B652C0A6469762E6461746564726F707065722E6C656166202E7069636B2D62746E207B0A2020636F6C6F723A2023316563643830';
wwv_flow_api.g_varchar2_table(258) := '3B0A7D0A6469762E6461746564726F707065722E6C656166202E7069636B65722C0A6469762E6461746564726F707065722E6C656166202E7069636B2D6C207B0A20206261636B67726F756E642D636F6C6F723A20236665666666323B0A7D0A6469762E';
wwv_flow_api.g_varchar2_table(259) := '6461746564726F707065722E6C656166202E7069636B65722C0A6469762E6461746564726F707065722E6C656166202E7069636B2D6172772C0A6469762E6461746564726F707065722E6C656166202E7069636B2D6C207B0A2020636F6C6F723A202335';
wwv_flow_api.g_varchar2_table(260) := '32383937313B0A7D0A6469762E6461746564726F707065722E6C656166202E7069636B2D6D2C0A6469762E6461746564726F707065722E6C656166202E7069636B2D6D202E7069636B2D6172772C0A6469762E6461746564726F707065722E6C65616620';
wwv_flow_api.g_varchar2_table(261) := '2E7069636B2D6C672D682C0A6469762E6461746564726F707065722E6C656166202E7069636B2D6C672D62202E7069636B2D736C2C0A6469762E6461746564726F707065722E6C656166202E7069636B2D7375626D6974207B0A2020636F6C6F723A2023';
wwv_flow_api.g_varchar2_table(262) := '6665666666323B0A7D0A6469762E6461746564726F707065722E6C6561662E7069636B65722D74696E793A6265666F72652C0A6469762E6461746564726F707065722E6C6561662E7069636B65722D74696E79202E7069636B2D6D207B0A20206261636B';
wwv_flow_api.g_varchar2_table(263) := '67726F756E642D636F6C6F723A20236665666666323B0A7D0A6469762E6461746564726F707065722E6C6561662E7069636B65722D74696E79202E7069636B2D6D2C0A6469762E6461746564726F707065722E6C6561662E7069636B65722D74696E7920';
wwv_flow_api.g_varchar2_table(264) := '2E7069636B2D6D202E7069636B2D617277207B0A2020636F6C6F723A20233532383937313B0A7D0A6469762E6461746564726F707065722E7072696D617279207B0A2020626F726465722D7261646975733A203670783B0A202077696474683A20313830';
wwv_flow_api.g_varchar2_table(265) := '70783B0A7D0A6469762E6461746564726F707065722E7072696D617279202E7069636B6572207B0A2020626F726465722D7261646975733A203670783B0A2020626F782D736861646F773A2030203020333270782030207267626128302C20302C20302C';
wwv_flow_api.g_varchar2_table(266) := '20302E31293B0A7D0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C207B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A203670783B0A2020626F726465722D626F74746F6D2D72696768742D72';
wwv_flow_api.g_varchar2_table(267) := '61646975733A203670783B0A7D0A6469762E6461746564726F707065722E7072696D6172793A6265666F72652C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D7375626D69742C0A6469762E6461746564726F707065722E';
wwv_flow_api.g_varchar2_table(268) := '7072696D617279202E7069636B2D6C672D62202E7069636B2D736C3A6265666F72652C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6D2C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C';
wwv_flow_api.g_varchar2_table(269) := '672D68207B0A20206261636B67726F756E642D636F6C6F723A20236664343734313B0A7D0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D792E7069636B2D6A756D702C0A6469762E6461746564726F707065722E7072696D';
wwv_flow_api.g_varchar2_table(270) := '617279202E7069636B206C69207370616E2C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C672D62202E7069636B2D776B652C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D62746E207B';
wwv_flow_api.g_varchar2_table(271) := '0A2020636F6C6F723A20236664343734313B0A7D0A6469762E6461746564726F707065722E7072696D617279202E7069636B65722C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C207B0A20206261636B67726F756E64';
wwv_flow_api.g_varchar2_table(272) := '2D636F6C6F723A20236666666666663B0A7D0A6469762E6461746564726F707065722E7072696D617279202E7069636B65722C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6172772C0A6469762E6461746564726F7070';
wwv_flow_api.g_varchar2_table(273) := '65722E7072696D617279202E7069636B2D6C207B0A2020636F6C6F723A20233464346434643B0A7D0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6D2C0A6469762E6461746564726F707065722E7072696D617279202E70';
wwv_flow_api.g_varchar2_table(274) := '69636B2D6D202E7069636B2D6172772C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C672D682C0A6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C672D62202E7069636B2D736C2C0A6469';
wwv_flow_api.g_varchar2_table(275) := '762E6461746564726F707065722E7072696D617279202E7069636B2D7375626D6974207B0A2020636F6C6F723A20236666666666663B0A7D0A6469762E6461746564726F707065722E7072696D6172792E7069636B65722D74696E793A6265666F72652C';
wwv_flow_api.g_varchar2_table(276) := '0A6469762E6461746564726F707065722E7072696D6172792E7069636B65722D74696E79202E7069636B2D6D207B0A20206261636B67726F756E642D636F6C6F723A20236666666666663B0A7D0A6469762E6461746564726F707065722E7072696D6172';
wwv_flow_api.g_varchar2_table(277) := '792E7069636B65722D74696E79202E7069636B2D6D2C0A6469762E6461746564726F707065722E7072696D6172792E7069636B65722D74696E79202E7069636B2D6D202E7069636B2D617277207B0A2020636F6C6F723A20233464346434643B0A7D0A64';
wwv_flow_api.g_varchar2_table(278) := '69762E6461746564726F70706572202E6E756C6C207B0A20202D7765626B69742D7472616E736974696F6E3A206E6F6E653B0A20202D6D6F7A2D7472616E736974696F6E3A206E6F6E653B0A20202D6D732D7472616E736974696F6E3A206E6F6E653B0A';
wwv_flow_api.g_varchar2_table(279) := '20202D6F2D7472616E736974696F6E3A206E6F6E653B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395083404577574691)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/lib/Datedropper3/datedropper.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2866756E6374696F6E282429207B0A097661720A09092F2F20435353204556454E54204445544543540A090963737365203D207B0A09090974203A20277472616E736974696F6E656E64207765626B69745472616E736974696F6E456E64206F5472616E';
wwv_flow_api.g_varchar2_table(2) := '736974696F6E456E64206F7472616E736974696F6E656E64204D535472616E736974696F6E456E64272C0A09090961203A20277765626B6974416E696D6174696F6E456E64206D6F7A416E696D6174696F6E456E64206F416E696D6174696F6E456E6420';
wwv_flow_api.g_varchar2_table(3) := '6F616E696D6174696F6E656E6420616E696D6174696F6E656E64270A09097D2C0A09092F2F204931384E0A09096931386E203D207B0A09090927656E27203A207B0A090909096E616D65203A2027456E676C697368272C0A09090909677265676F726961';
wwv_flow_api.g_varchar2_table(4) := '6E203A2066616C73652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A090909090909274A616E272C0A09090909090927466562272C0A090909090909274D6172272C0A09090909090927417072272C0A090909090909274D';
wwv_flow_api.g_varchar2_table(5) := '6179272C0A090909090909274A756E65272C0A090909090909274A756C79272C0A09090909090927417567272C0A0909090909092753657074272C0A090909090909274F6374272C0A090909090909274E6F76272C0A09090909090927446563270A0909';
wwv_flow_api.g_varchar2_table(6) := '0909095D2C0A090909090966756C6C203A205B0A090909090909274A616E75617279272C0A090909090909274665627275617279272C0A090909090909274D61726368272C0A09090909090927417072696C272C0A090909090909274D6179272C0A0909';
wwv_flow_api.g_varchar2_table(7) := '09090909274A756E65272C0A090909090909274A756C79272C0A09090909090927417567757374272C0A0909090909092753657074656D626572272C0A090909090909274F63746F626572272C0A090909090909274E6F76656D626572272C0A09090909';
wwv_flow_api.g_varchar2_table(8) := '090927446563656D626572270A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A0909090909092753272C0A090909090909274D272C0A0909090909092754272C0A0909090909092757';
wwv_flow_api.g_varchar2_table(9) := '272C0A0909090909092754272C0A0909090909092746272C0A0909090909092753270A09090909095D2C0A090909090966756C6C203A205B0A0909090909092753756E646179272C0A090909090909274D6F6E646179272C0A0909090909092754756573';
wwv_flow_api.g_varchar2_table(10) := '646179272C0A090909090909275765646E6573646179272C0A090909090909275468757273646179272C0A09090909090927467269646179272C0A090909090909275361747572646179270A09090909095D0A090909097D0A0909097D2C0A090909276B';
wwv_flow_api.g_varchar2_table(11) := '6127203A207B0A090909096E616D65203A202747656F726769616E272C0A09090909677265676F7269616E203A2066616C73652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A09090909090927E18398E18390E1839C272C';
wwv_flow_api.g_varchar2_table(12) := '0A09090909090927E18397E18394E18391272C0A09090909090927E1839BE18390E183A0E183A2272C0A09090909090927E18390E1839EE183A0272C0A09090909090927E1839BE18390E18398272C0A09090909090927E18398E18395E1839C272C0A09';
wwv_flow_api.g_varchar2_table(13) := '090909090927E18398E18395E1839A272C0A09090909090927E18390E18392E18395272C0A09090909090927E183A1E18394E183A5E183A2272C0A09090909090927E1839DE183A5E183A2272C0A09090909090927E1839CE1839DE18394E1839BE18391';
wwv_flow_api.g_varchar2_table(14) := '272C0A09090909090927E18393E18394E18399270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927E18398E18390E1839CE18395E18390E183A0E18398272C0A09090909090927E18397E18394E18391E18394E183A0E18395E1';
wwv_flow_api.g_varchar2_table(15) := '8390E1839AE18398272C0A09090909090927E1839BE18390E183A0E183A2E18398272C0A09090909090927E18390E1839EE183A0E18398E1839AE18398272C0A09090909090927E1839BE18390E18398E183A1E18398272C0A09090909090927E18398E1';
wwv_flow_api.g_varchar2_table(16) := '8395E1839CE18398E183A1E18398272C0A09090909090927E18398E18395E1839AE18398E183A1E18398272C0A09090909090927E18390E18392E18395E18398E183A1E183A2E1839D272C0A09090909090927E183A1E18394E183A5E183A2E18394E183';
wwv_flow_api.g_varchar2_table(17) := '9BE18391E18394E183A0E18398272C0A09090909090927E1839DE183A5E183A2E1839DE1839BE18391E18394E183A0E18398272C0A09090909090927E1839CE1839DE18394E1839BE18391E18394E183A0E18398272C0A09090909090927E18393E18394';
wwv_flow_api.g_varchar2_table(18) := 'E18399E18394E1839BE18391E18394E183A0E18398270A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A09090909090927E18399E18395272C0A09090909090927E1839DE183A0272C';
wwv_flow_api.g_varchar2_table(19) := '0A09090909090927E183A1E18390E1839B272C0A09090909090927E1839DE18397E183AE272C0A09090909090927E183AEE183A3E18397272C0A09090909090927E1839EE18390E183A0272C0A09090909090927E183A8E18390E18391270A0909090909';
wwv_flow_api.g_varchar2_table(20) := '5D2C0A090909090966756C6C203A205B0A09090909090927E18399E18395E18398E183A0E18390272C0A09090909090927E1839DE183A0E183A8E18390E18391E18390E18397E18398272C0A09090909090927E183A1E18390E1839BE183A8E18390E183';
wwv_flow_api.g_varchar2_table(21) := '91E18390E18397E18398272C0A09090909090927E1839DE18397E183AEE183A8E18390E18391E18390E18397E18398272C0A09090909090927E183AEE183A3E18397E183A8E18390E18391E18390E18397E18398272C0A09090909090927E1839EE18390';
wwv_flow_api.g_varchar2_table(22) := 'E183A0E18390E183A1E18399E18394E18395E18398272C0A09090909090927E183A8E18390E18391E18390E18397E18398270A09090909095D0A090909097D0A0909097D2C2F2F0A09090927697427203A207B0A090909096E616D65203A20274974616C';
wwv_flow_api.g_varchar2_table(23) := '69616E6F272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A0909090909092747656E272C0A09090909090927466562272C0A090909090909274D6172272C0A090909';
wwv_flow_api.g_varchar2_table(24) := '09090927417072272C0A090909090909274D6167272C0A09090909090927476975272C0A090909090909274C7567272C0A0909090909092741676F272C0A09090909090927536574272C0A090909090909274F7474272C0A090909090909274E6F76272C';
wwv_flow_api.g_varchar2_table(25) := '0A09090909090927446963270A09090909095D2C0A090909090966756C6C203A205B0A0909090909092747656E6E61696F272C0A09090909090927466562627261696F272C0A090909090909274D61727A6F272C0A09090909090927417072696C65272C';
wwv_flow_api.g_varchar2_table(26) := '0A090909090909274D616767696F272C0A09090909090927476975676E6F272C0A090909090909274C75676C696F272C0A0909090909092741676F73746F272C0A0909090909092753657474656D627265272C0A090909090909274F74746F627265272C';
wwv_flow_api.g_varchar2_table(27) := '0A090909090909274E6F76656D627265272C0A09090909090927446963656D627265270A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A0909090909092744272C0A09090909090927';
wwv_flow_api.g_varchar2_table(28) := '4C272C0A090909090909274D272C0A090909090909274D272C0A0909090909092747272C0A0909090909092756272C0A0909090909092753270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927446F6D656E696361272C0A0909';
wwv_flow_api.g_varchar2_table(29) := '09090909274C756E6564C3AC272C0A090909090909274D6172746564C3AC272C0A090909090909274D6572636F6C6564C3AC272C0A0909090909092747696F766564C3AC272C0A0909090909092756656E657264C3AC272C0A0909090909092753616261';
wwv_flow_api.g_varchar2_table(30) := '746F270A09090909095D0A090909097D0A0909097D2C0A09090927667227203A207B0A090909096E616D65203A20274672616EC3A7616973272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A09090909';
wwv_flow_api.g_varchar2_table(31) := '0973686F72743A205B0A090909090909274A616E272C0A0909090909092746C3A976272C0A090909090909274D6172272C0A09090909090927417672272C0A090909090909274D6169272C0A090909090909274A7569272C0A090909090909274A756927';
wwv_flow_api.g_varchar2_table(32) := '2C0A09090909090927416FC3BB272C0A09090909090927536570272C0A090909090909274F6374272C0A090909090909274E6F76272C0A0909090909092744C3A963270A09090909095D2C0A090909090966756C6C203A205B0A090909090909274A616E';
wwv_flow_api.g_varchar2_table(33) := '76696572272C0A0909090909092746C3A97672696572272C0A090909090909274D617273272C0A09090909090927417672696C272C0A090909090909274D6169272C0A090909090909274A75696E272C0A090909090909274A75696C6C6574272C0A0909';
wwv_flow_api.g_varchar2_table(34) := '0909090927416FC3BB74272C0A0909090909092753657074656D627265272C0A090909090909274F63746F627265272C0A090909090909274E6F76656D627265272C0A0909090909092744C3A963656D627265270A09090909095D0A090909097D2C0A09';
wwv_flow_api.g_varchar2_table(35) := '0909097765656B64617973203A207B0A090909090973686F7274203A205B0A0909090909092744272C0A090909090909274C272C0A090909090909274D272C0A090909090909274D272C0A090909090909274A272C0A0909090909092756272C0A090909';
wwv_flow_api.g_varchar2_table(36) := '0909092753270A09090909095D2C0A090909090966756C6C203A205B0A0909090909092744696D616E636865272C0A090909090909274C756E6469272C0A090909090909274D61726469272C0A090909090909274D65726372656469272C0A0909090909';
wwv_flow_api.g_varchar2_table(37) := '09274A65756469272C0A0909090909092756656E6472656469272C0A0909090909092753616D656469270A09090909095D0A090909097D0A0909097D2C0A090909277A6827203A207B0A090909096E616D65203A2027E4B8ADE69687272C0A0909090967';
wwv_flow_api.g_varchar2_table(38) := '7265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A09090909090927E4B880E69C88272C0A09090909090927E4BA8CE69C88272C0A09090909090927E4B889E69C88272C0A090909090909';
wwv_flow_api.g_varchar2_table(39) := '27E59B9BE69C88272C0A09090909090927E4BA94E69C88272C0A09090909090927E585ADE69C88272C0A09090909090927E4B883E69C88272C0A09090909090927E585ABE69C88272C0A09090909090927E4B99DE69C88272C0A09090909090927E58D81';
wwv_flow_api.g_varchar2_table(40) := 'E69C88272C0A09090909090927E58D81E4B880E69C88272C0A09090909090927E58D81E4BA8CE69C88270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927E4B880E69C88272C0A09090909090927E4BA8CE69C88272C0A090909';
wwv_flow_api.g_varchar2_table(41) := '09090927E4B889E69C88272C0A09090909090927E59B9BE69C88272C0A09090909090927E4BA94E69C88272C0A09090909090927E585ADE69C88272C0A09090909090927E4B883E69C88272C0A09090909090927E585ABE69C88272C0A09090909090927';
wwv_flow_api.g_varchar2_table(42) := 'E4B99DE69C88272C0A09090909090927E58D81E69C88272C0A09090909090927E58D81E4B880E69C88272C0A09090909090927E58D81E4BA8CE69C88270A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A09090909097368';
wwv_flow_api.g_varchar2_table(43) := '6F7274203A205B0A09090909090927E5A4A9272C0A09090909090927E4B880272C0A09090909090927E4BA8C272C0A09090909090927E4B889272C0A09090909090927E59B9B272C0A09090909090927E4BA94272C0A09090909090927E585AD270A0909';
wwv_flow_api.g_varchar2_table(44) := '0909095D2C0A090909090966756C6C203A205B0A09090909090927E6989FE69C9FE5A4A9272C0A09090909090927E6989FE69C9FE4B880272C0A09090909090927E6989FE69C9FE4BA8C272C0A09090909090927E6989FE69C9FE4B889272C0A09090909';
wwv_flow_api.g_varchar2_table(45) := '090927E6989FE69C9FE59B9B272C0A09090909090927E6989FE69C9FE4BA94272C0A09090909090927E6989FE69C9FE585AD270A09090909095D0A090909097D0A0909097D2C0A09090927617227203A207B0A090909096E616D65203A2027D8A7D984D8';
wwv_flow_api.g_varchar2_table(46) := 'B9D98ED8B1D98ED8A8D990D98AD98ED991D8A9272C0A09090909677265676F7269616E203A2066616C73652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A09090909090927D8ACD8A7D986D981D98A272C0A090909090909';
wwv_flow_api.g_varchar2_table(47) := '27D981D98AD981D8B1D98A272C0A09090909090927D985D8A7D8B1D8B3272C0A09090909090927D8A3D981D8B1D98AD984272C0A09090909090927D985D8A7D98A272C0A09090909090927D8ACD988D8A7D986272C0A09090909090927D8ACD988D98AD9';
wwv_flow_api.g_varchar2_table(48) := '84D98AD8A9272C0A09090909090927D8A3D988D8AA272C0A09090909090927D8B3D8A8D8AAD985D8A8D8B1272C0A09090909090927D8A3D983D8AAD988D8A8D8B1272C0A09090909090927D986D988D981D985D8A8D8B1272C0A09090909090927D8AFD9';
wwv_flow_api.g_varchar2_table(49) := '8AD8B3D985D8A8D8B1270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927D8ACD8A7D986D981D98A272C0A09090909090927D981D98AD981D8B1D98A272C0A09090909090927D985D8A7D8B1D8B3272C0A09090909090927D8A3';
wwv_flow_api.g_varchar2_table(50) := 'D981D8B1D98AD984272C0A09090909090927D985D8A7D98A272C0A09090909090927D8ACD988D8A7D986272C0A09090909090927D8ACD988D98AD984D98AD8A9272C0A09090909090927D8A3D988D8AA272C0A09090909090927D8B3D8A8D8AAD985D8A8';
wwv_flow_api.g_varchar2_table(51) := 'D8B1272C0A09090909090927D8A3D983D8AAD988D8A8D8B1272C0A09090909090927D986D988D981D985D8A8D8B1272C0A09090909090927D8AFD98AD8B3D985D8A8D8B1270A09090909095D0A090909097D2C0A090909097765656B64617973203A207B';
wwv_flow_api.g_varchar2_table(52) := '0A090909090973686F7274203A205B0A0909090909092753272C0A090909090909274D272C0A0909090909092754272C0A0909090909092757272C0A0909090909092754272C0A0909090909092746272C0A0909090909092753270A09090909095D2C0A';
wwv_flow_api.g_varchar2_table(53) := '090909090966756C6C203A205B0A09090909090927D8A7D984D8A3D8ADD8AF272C0A09090909090927D8A7D984D8A5D8ABD986D98AD986272C0A09090909090927D8A7D984D8ABD984D8ABD8A7D8A1272C0A09090909090927D8A7D984D8A3D8B1D8A8D8';
wwv_flow_api.g_varchar2_table(54) := 'B9D8A7D8A1272C0A09090909090927D8A7D984D8AED985D98AD8B3272C0A09090909090927D8A7D984D8ACD985D8B9D8A9272C0A09090909090927D8A7D984D8B3D8A8D8AA270A09090909095D0A090909097D0A0909097D2C0A09090927666127203A20';
wwv_flow_api.g_varchar2_table(55) := '7B0A090909096E616D65203A2027D981D8A7D8B1D8B3DB8C272C0A09090909677265676F7269616E203A2066616C73652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A09090909090927DA98D8A7D986D988DB8CD987272C';
wwv_flow_api.g_varchar2_table(56) := '0A09090909090927D981D988D988D8B1DB8CD987272C0A09090909090927D985D8A7D8B1DA86272C0A09090909090927D8A2D9BED8B1DB8CD984272C0A09090909090927D985DB8C272C0A09090909090927D8ACD988D986272C0A09090909090927D8AC';
wwv_flow_api.g_varchar2_table(57) := 'D988D984D8A7DB8C272C0A09090909090927D8A2DAAFD988D8B3D8AA272C0A09090909090927D8B3D9BED8AAD8A7D985D8A8D8B1272C0A09090909090927D8A7DAA9D8AAD8A8D8B1272C0A09090909090927D986D988D8A7D985D8A8D8B1272C0A090909';
wwv_flow_api.g_varchar2_table(58) := '09090927D8AFD8B3D8A7D985D8A8D8B1270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927DA98D8A7D986D988DB8CD987272C0A09090909090927D981D988D988D8B1DB8CD987272C0A09090909090927D985D8A7D8B1DA8627';
wwv_flow_api.g_varchar2_table(59) := '2C0A09090909090927D8A2D9BED8B1DB8CD984272C0A09090909090927D985DB8C272C0A09090909090927D8ACD988D986272C0A09090909090927D8ACD988D984D8A7DB8C272C0A09090909090927D8A2DAAFD988D8B3D8AA272C0A09090909090927D8';
wwv_flow_api.g_varchar2_table(60) := 'B3D9BED8AAD8A7D985D8A8D8B1272C0A09090909090927D8A7DAA9D8AAD8A8D8B1272C0A09090909090927D986D988D8A7D985D8A8D8B1272C0A09090909090927D8AFD8B3D8A7D985D8A8D8B1270A09090909095D0A090909097D2C0A09090909776565';
wwv_flow_api.g_varchar2_table(61) := '6B64617973203A207B0A090909090973686F7274203A205B0A0909090909092753272C0A090909090909274D272C0A0909090909092754272C0A0909090909092757272C0A0909090909092754272C0A0909090909092746272C0A090909090909275327';
wwv_flow_api.g_varchar2_table(62) := '0A09090909095D2C0A090909090966756C6C203A205B0A09090909090927DB8CDAA9D8B4D986D8A8D987272C0A09090909090927D8AFD988D8B4D986D8A8D987272C0A09090909090927D8B3D98720D8B4D986D8A8D987272C0A09090909090927DA86D9';
wwv_flow_api.g_varchar2_table(63) := '87D8A7D8B1D8B4D986D8A8D987272C0A09090909090927D9BED986D8AC20D8B4D986D8A8D987272C0A09090909090927D8ACD985D8B9D987272C0A09090909090927D8B4D986D8A8D987270A09090909095D0A090909097D0A0909097D2C0A0909092768';
wwv_flow_api.g_varchar2_table(64) := '7527203A207B0A090909096E616D65203A202748756E67617269616E272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A090909090909226A616E222C0A0909090909';
wwv_flow_api.g_varchar2_table(65) := '0922666562222C0A090909090909226DC3A172222C0A09090909090922C3A17072222C0A090909090909226DC3A16A222C0A090909090909226AC3BA6E222C0A090909090909226AC3BA6C222C0A09090909090922617567222C0A09090909090922737A';
wwv_flow_api.g_varchar2_table(66) := '65222C0A090909090909226F6B74222C0A090909090909226E6F76222C0A09090909090922646563220A09090909095D2C0A090909090966756C6C203A205B0A090909090909226A616E75C3A172222C0A090909090909226665627275C3A172222C0A09';
wwv_flow_api.g_varchar2_table(67) := '0909090909226DC3A17263697573222C0A09090909090922C3A17072696C6973222C0A090909090909226DC3A16A7573222C0A090909090909226AC3BA6E697573222C0A090909090909226AC3BA6C697573222C0A0909090909092261756775737A7475';
wwv_flow_api.g_varchar2_table(68) := '73222C0A09090909090922737A657074656D626572222C0A090909090909226F6B74C3B3626572222C0A090909090909226E6F76656D626572222C0A09090909090922646563656D626572220A09090909095D0A090909097D2C0A090909097765656B64';
wwv_flow_api.g_varchar2_table(69) := '617973203A207B0A090909090973686F7274203A205B0A0909090909092776272C0A0909090909092768272C0A090909090909276B272C0A0909090909092773272C0A0909090909092763272C0A0909090909092770272C0A0909090909092773270A09';
wwv_flow_api.g_varchar2_table(70) := '090909095D2C0A090909090966756C6C203A205B0A09090909090927766173C3A1726E6170272C0A0909090909092768C3A97466C591272C0A090909090909276B656464272C0A09090909090927737A65726461272C0A090909090909276373C3BC74C3';
wwv_flow_api.g_varchar2_table(71) := 'B67274C3B66B272C0A0909090909092770C3A96E74656B272C0A09090909090927737A6F6D626174270A09090909095D0A090909097D0A0909097D2C0A09090927677227203A207B0A090909096E616D65203A2027CE95CEBBCEBBCEB7CEBDCEB9CEBACE';
wwv_flow_api.g_varchar2_table(72) := 'AC272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A09090909090922CE99CEB1CEBD222C0A09090909090922CEA6CEB5CEB2222C0A09090909090922CE9CCEACCF81';
wwv_flow_api.g_varchar2_table(73) := '222C0A09090909090922CE91CF80CF81222C0A09090909090922CE9CCEACCEB9222C0A09090909090922CE99CEBFCF8DCEBD222C0A09090909090922CE99CEBFCF8DCEBB222C0A09090909090922CE91CF8DCEB3222C0A09090909090922CEA3CEB5CF80';
wwv_flow_api.g_varchar2_table(74) := '222C0A09090909090922CE9FCEBACF84222C0A09090909090922CE9DCEBFCEAD222C0A09090909090922CE94CEB5CEBA220A09090909095D2C0A090909090966756C6C203A205B0A09090909090922CE99CEB1CEBDCEBFCF85CEACCF81CEB9CEBFCF8222';
wwv_flow_api.g_varchar2_table(75) := '2C0A09090909090922CEA6CEB5CEB2CF81CEBFCF85CEACCF81CEB9CEBFCF82222C0A09090909090922CE9CCEACCF81CF84CEB9CEBFCF82222C0A09090909090922CE91CF80CF81CEAFCEBBCEB9CEBFCF82222C0A09090909090922CE9CCEACCEB9CEBFCF';
wwv_flow_api.g_varchar2_table(76) := '82222C0A09090909090922CE99CEBFCF8DCEBDCEB9CEBFCF82222C0A09090909090922CE99CEBFCF8DCEBBCEB9CEBFCF82222C0A09090909090922CE91CF8DCEB3CEBFCF85CF83CF84CEBFCF82222C0A09090909090922CEA3CEB5CF80CF84CEADCEBCCE';
wwv_flow_api.g_varchar2_table(77) := 'B2CF81CEB9CEBFCF82222C0A09090909090922CE9FCEBACF84CF8ECEB2CF81CEB9CEBFCF82222C0A09090909090922CE9DCEBFCEADCEBCCEB2CF81CEB9CEBFCF82222C0A09090909090922CE94CEB5CEBACEADCEBCCEB2CF81CEB9CEBFCF82220A090909';
wwv_flow_api.g_varchar2_table(78) := '09095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A09090909090927CE9A272C0A09090909090927CE94272C0A09090909090927CEA4272C0A09090909090927CEA4272C0A09090909090927CEA0';
wwv_flow_api.g_varchar2_table(79) := '272C0A09090909090927CEA0272C0A09090909090927CEA3270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927CE9ACF85CF81CEB9CEB1CEBACEAE272C0A09090909090927CE94CEB5CF85CF84CEADCF81CEB1272C0A09090909';
wwv_flow_api.g_varchar2_table(80) := '090927CEA4CF81CEAFCF84CEB7272C0A09090909090927CEA4CEB5CF84CEACCF81CF84CEB7272C0A09090909090927CEA0CEADCEBCCF80CF84CEB7272C0A09090909090927CEA0CEB1CF81CEB1CF83CEBACEB5CF85CEAE272C0A09090909090927CEA3CE';
wwv_flow_api.g_varchar2_table(81) := 'ACCEB2CEB2CEB1CF84CEBF270A09090909095D0A090909097D0A0909097D2C0A09090927657327203A207B0A090909096E616D65203A202745737061C3B16F6C272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E74687320';
wwv_flow_api.g_varchar2_table(82) := '3A207B0A090909090973686F72743A205B0A09090909090922456E65222C0A09090909090922466562222C0A090909090909224D6172222C0A09090909090922416272222C0A090909090909224D6179222C0A090909090909224A756E222C0A09090909';
wwv_flow_api.g_varchar2_table(83) := '0909224A756C222C0A0909090909092241676F222C0A09090909090922536570222C0A090909090909224F6374222C0A090909090909224E6F76222C0A09090909090922446963220A09090909095D2C0A090909090966756C6C203A205B0A0909090909';
wwv_flow_api.g_varchar2_table(84) := '0922456E65726F222C0A090909090909224665627265726F222C0A090909090909224D61727A6F222C0A09090909090922416272696C222C0A090909090909224D61796F222C0A090909090909224A756E696F222C0A090909090909224A756C696F222C';
wwv_flow_api.g_varchar2_table(85) := '0A0909090909092241676F73746F222C0A090909090909225365707469656D627265222C0A090909090909224F637475627265222C0A090909090909224E6F7669656D627265222C0A0909090909092244696369656D627265220A09090909095D0A0909';
wwv_flow_api.g_varchar2_table(86) := '09097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A0909090909092744272C0A090909090909274C272C0A090909090909274D272C0A0909090909092758272C0A090909090909274A272C0A0909090909092756';
wwv_flow_api.g_varchar2_table(87) := '272C0A0909090909092753270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927446F6D696E676F272C0A090909090909274C756E6573272C0A090909090909274D6172746573272C0A090909090909274D69C3A972636F6C6573';
wwv_flow_api.g_varchar2_table(88) := '272C0A090909090909274A7565766573272C0A09090909090927566965726E6573272C0A0909090909092753C3A16261646F270A09090909095D0A090909097D0A0909097D2C0A09090927646127203A207B0A090909096E616D65203A202744616E736B';
wwv_flow_api.g_varchar2_table(89) := '272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A090909090909226A616E222C0A09090909090922666562222C0A090909090909226D6172222C0A09090909090922';
wwv_flow_api.g_varchar2_table(90) := '617072222C0A090909090909226D616A222C0A090909090909226A756E222C0A090909090909226A756C222C0A09090909090922617567222C0A09090909090922736570222C0A090909090909226F6B74222C0A090909090909226E6F76222C0A090909';
wwv_flow_api.g_varchar2_table(91) := '09090922646563220A09090909095D2C0A090909090966756C6C203A205B0A090909090909226A616E756172222C0A0909090909092266656272756172222C0A090909090909226D61727473222C0A09090909090922617072696C222C0A090909090909';
wwv_flow_api.g_varchar2_table(92) := '226D616A222C0A090909090909226A756E69222C0A090909090909226A756C69222C0A09090909090922617567757374222C0A0909090909092273657074656D626572222C0A090909090909226F6B746F626572222C0A090909090909226E6F76656D62';
wwv_flow_api.g_varchar2_table(93) := '6572222C0A09090909090922646563656D626572220A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A0909090909092773272C0A090909090909276D272C0A0909090909092774272C';
wwv_flow_api.g_varchar2_table(94) := '0A090909090909276F272C0A0909090909092774272C0A0909090909092766272C0A090909090909276C270A09090909095D2C0A090909090966756C6C203A205B0A0909090909092773C3B86E646167272C0A090909090909276D616E646167272C0A09';
wwv_flow_api.g_varchar2_table(95) := '09090909092774697273646167272C0A090909090909276F6E73646167272C0A09090909090927746F7273646167272C0A09090909090927667265646167272C0A090909090909276CC3B872646167270A09090909095D0A090909097D0A0909097D2C0A';
wwv_flow_api.g_varchar2_table(96) := '09090927646527203A207B0A090909096E616D65203A202744657574736368272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A090909090909224A616E222C0A0909';
wwv_flow_api.g_varchar2_table(97) := '0909090922466562222C0A090909090909224DC3A472222C0A09090909090922417072222C0A090909090909224D6169222C0A090909090909224A756E222C0A090909090909224A756C222C0A09090909090922417567222C0A09090909090922536570';
wwv_flow_api.g_varchar2_table(98) := '222C0A090909090909224F6B74222C0A090909090909224E6F76222C0A0909090909092244657A220A09090909095D2C0A090909090966756C6C203A205B0A090909090909224A616E756172222C0A0909090909092246656272756172222C0A09090909';
wwv_flow_api.g_varchar2_table(99) := '0909224DC3A4727A222C0A09090909090922417072696C222C0A090909090909224D6169222C0A090909090909224A756E69222C0A090909090909224A756C69222C0A09090909090922417567757374222C0A0909090909092253657074656D62657222';
wwv_flow_api.g_varchar2_table(100) := '2C0A090909090909224F6B746F626572222C0A090909090909224E6F76656D626572222C0A0909090909092244657A656D626572220A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A';
wwv_flow_api.g_varchar2_table(101) := '0909090909092753272C0A090909090909274D272C0A0909090909092744272C0A090909090909274D272C0A0909090909092744272C0A0909090909092746272C0A0909090909092753270A09090909095D2C0A090909090966756C6C203A205B0A0909';
wwv_flow_api.g_varchar2_table(102) := '0909090927536F6E6E746167272C0A090909090909274D6F6E746167272C0A090909090909274469656E73746167272C0A090909090909274D697474776F6368272C0A09090909090927446F6E6E657273746167272C0A09090909090927467265697461';
wwv_flow_api.g_varchar2_table(103) := '67272C0A0909090909092753616D73746167270A09090909095D0A090909097D0A0909097D2C0A090909276E6C27203A207B0A090909096E616D65203A20274E656465726C616E6473272C0A09090909677265676F7269616E203A20747275652C0A0909';
wwv_flow_api.g_varchar2_table(104) := '09096D6F6E746873203A207B0A090909090973686F72743A205B0A090909090909226A616E222C0A09090909090922666562222C0A090909090909226D6161222C0A09090909090922617072222C0A090909090909226D6569222C0A090909090909226A';
wwv_flow_api.g_varchar2_table(105) := '756E222C0A090909090909226A756C222C0A09090909090922617567222C0A09090909090922736570222C0A090909090909226F6B74222C0A090909090909226E6F76222C0A09090909090922646563220A09090909095D2C0A090909090966756C6C20';
wwv_flow_api.g_varchar2_table(106) := '3A205B0A090909090909226A616E75617269222C0A090909090909226665627275617269222C0A090909090909226D61617274222C0A09090909090922617072696C222C0A090909090909226D6569222C0A090909090909226A756E69222C0A09090909';
wwv_flow_api.g_varchar2_table(107) := '0909226A756C69222C0A090909090909226175677573747573222C0A0909090909092273657074656D626572222C0A090909090909226F6B746F626572222C0A090909090909226E6F76656D626572222C0A09090909090922646563656D626572220A09';
wwv_flow_api.g_varchar2_table(108) := '090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A090909090909277A272C0A090909090909276D272C0A0909090909092764272C0A0909090909092777272C0A0909090909092764272C0A';
wwv_flow_api.g_varchar2_table(109) := '0909090909092776272C0A090909090909277A270A09090909095D2C0A090909090966756C6C203A205B0A090909090909277A6F6E646167272C0A090909090909276D61616E646167272C0A0909090909092764696E73646167272C0A09090909090927';
wwv_flow_api.g_varchar2_table(110) := '776F656E73646167272C0A09090909090927646F6E646572646167272C0A090909090909277672696A646167272C0A090909090909277A61746572646167270A09090909095D0A090909097D0A0909097D2C0A09090927706C27203A207B0A090909096E';
wwv_flow_api.g_varchar2_table(111) := '616D65203A20276AC4997A796B20706F6C736B69272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A09090909090922737479222C0A090909090909226C7574222C0A';
wwv_flow_api.g_varchar2_table(112) := '090909090909226D6172222C0A090909090909226B7769222C0A090909090909226D616A222C0A09090909090922637A65222C0A090909090909226C6970222C0A09090909090922736965222C0A0909090909092277727A222C0A090909090909227061';
wwv_flow_api.g_varchar2_table(113) := 'C5BA222C0A090909090909226C6973222C0A09090909090922677275220A09090909095D2C0A090909090966756C6C203A205B0A09090909090922737479637A65C584222C0A090909090909226C757479222C0A090909090909226D61727A6563222C0A';
wwv_flow_api.g_varchar2_table(114) := '090909090909226B776965636965C584222C0A090909090909226D616A222C0A09090909090922637A657277696563222C0A090909090909226C6970696563222C0A0909090909092273696572706965C584222C0A0909090909092277727A65736965C5';
wwv_flow_api.g_varchar2_table(115) := '84222C0A090909090909227061C5BA647A6965726E696B222C0A090909090909226C6973746F706164222C0A09090909090922677275647A6965C584220A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A09090909097368';
wwv_flow_api.g_varchar2_table(116) := '6F7274203A205B0A090909090909276E272C0A0909090909092770272C0A0909090909092777272C0A09090909090927C59B272C0A0909090909092763272C0A0909090909092770272C0A0909090909092773270A09090909095D2C0A09090909096675';
wwv_flow_api.g_varchar2_table(117) := '6C6C203A205B0A090909090909276E6965647A69656C61272C0A09090909090927706F6E6965647A6961C582656B272C0A0909090909092777746F72656B272C0A09090909090927C59B726F6461272C0A09090909090927637A77617274656B272C0A09';
wwv_flow_api.g_varchar2_table(118) := '0909090909277069C48574656B272C0A09090909090927736F626F7461270A09090909095D0A090909097D0A0909097D2C0A09090927707427203A207B0A090909096E616D65203A2027506F7274756775C3AA73272C0A09090909677265676F7269616E';
wwv_flow_api.g_varchar2_table(119) := '203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A090909090909224A616E6569726F222C0A0909090909092246657665726569726F222C0A090909090909224D6172C3A76F222C0A09090909090922416272';
wwv_flow_api.g_varchar2_table(120) := '696C222C0A090909090909224D61696F222C0A090909090909224A756E686F222C0A090909090909224A756C686F222C0A0909090909092241676F73746F222C0A09090909090922536574656D62726F222C0A090909090909224F75747562726F222C0A';
wwv_flow_api.g_varchar2_table(121) := '090909090909224E6F76656D62726F222C0A0909090909092244657A656D62726F220A09090909095D2C0A090909090966756C6C203A205B0A090909090909224A616E6569726F222C0A0909090909092246657665726569726F222C0A09090909090922';
wwv_flow_api.g_varchar2_table(122) := '4D6172C3A76F222C0A09090909090922416272696C222C0A090909090909224D61696F222C0A090909090909224A756E686F222C0A090909090909224A756C686F222C0A0909090909092241676F73746F222C0A09090909090922536574656D62726F22';
wwv_flow_api.g_varchar2_table(123) := '2C0A090909090909224F75747562726F222C0A090909090909224E6F76656D62726F222C0A0909090909092244657A656D62726F220A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A';
wwv_flow_api.g_varchar2_table(124) := '0909090909092244222C0A0909090909092253222C0A0909090909092254222C0A0909090909092251222C0A0909090909092251222C0A0909090909092253222C0A0909090909092253220A09090909095D2C0A090909090966756C6C203A205B0A0909';
wwv_flow_api.g_varchar2_table(125) := '0909090922446F6D696E676F222C0A09090909090922536567756E6461222C0A09090909090922546572C3A761222C0A09090909090922517561727461222C0A090909090909225175696E7461222C0A090909090909225365787461222C0A0909090909';
wwv_flow_api.g_varchar2_table(126) := '092253C3A16261646F220A09090909095D0A090909097D0A0909097D2C0A09090927736927203A207B0A090909096E616D65203A2027536C6F76656EC5A1C48D696E61272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E74';
wwv_flow_api.g_varchar2_table(127) := '6873203A207B0A090909090973686F72743A205B0A090909090909226A616E222C0A09090909090922666562222C0A090909090909226D6172222C0A09090909090922617072222C0A090909090909226D616A222C0A090909090909226A756E222C0A09';
wwv_flow_api.g_varchar2_table(128) := '0909090909226A756C222C0A09090909090922617667222C0A09090909090922736570222C0A090909090909226F6B74222C0A090909090909226E6F76222C0A09090909090922646563220A09090909095D2C0A090909090966756C6C203A205B0A0909';
wwv_flow_api.g_varchar2_table(129) := '09090909226A616E756172222C0A0909090909092266656272756172222C0A090909090909226D61726563222C0A09090909090922617072696C222C0A090909090909226D616A222C0A090909090909226A756E696A222C0A090909090909226A756C69';
wwv_flow_api.g_varchar2_table(130) := '6A222C0A09090909090922617667757374222C0A0909090909092273657074656D626572222C0A090909090909226F6B746F626572222C0A090909090909226E6F76656D626572222C0A09090909090922646563656D626572220A09090909095D0A0909';
wwv_flow_api.g_varchar2_table(131) := '09097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A090909090909276E272C0A0909090909092770272C0A0909090909092774272C0A0909090909092773272C0A09090909090927C48D272C0A09090909090927';
wwv_flow_api.g_varchar2_table(132) := '70272C0A0909090909092773270A09090909095D2C0A090909090966756C6C203A205B0A090909090909276E6564656C6A61272C0A09090909090927706F6E6564656C6A656B272C0A09090909090927746F72656B272C0A090909090909277372656461';
wwv_flow_api.g_varchar2_table(133) := '272C0A09090909090927C48D65747274656B272C0A09090909090927706574656B272C0A09090909090927736F626F7461270A09090909095D0A090909097D0A0909097D2C0A09090927756B27203A207B0A090909096E616D65203A2027D183D0BAD180';
wwv_flow_api.g_varchar2_table(134) := 'D0B0D197D0BDD181D18CD0BAD0B020D0BCD0BED0B2D0B0272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A09090909090922D181D196D187D0B5D0BDD18C222C0A09';
wwv_flow_api.g_varchar2_table(135) := '090909090922D0BBD18ED182D0B8D0B9222C0A09090909090922D0B1D0B5D180D0B5D0B7D0B5D0BDD18C222C0A09090909090922D0BAD0B2D196D182D0B5D0BDD18C222C0A09090909090922D182D180D0B0D0B2D0B5D0BDD18C222C0A09090909090922';
wwv_flow_api.g_varchar2_table(136) := 'D187D0B5D180D0B2D0B5D0BDD18C222C0A09090909090922D0BBD0B8D0BFD0B5D0BDD18C222C0A09090909090922D181D0B5D180D0BFD0B5D0BDD18C222C0A09090909090922D0B2D0B5D180D0B5D181D0B5D0BDD18C222C0A09090909090922D0B6D0BE';
wwv_flow_api.g_varchar2_table(137) := 'D0B2D182D0B5D0BDD18C222C0A09090909090922D0BBD0B8D181D182D0BED0BFD0B0D0B4222C0A09090909090922D0B3D180D183D0B4D0B5D0BDD18C220A09090909095D2C0A090909090966756C6C203A205B0A09090909090922D181D196D187D0B5D0';
wwv_flow_api.g_varchar2_table(138) := 'BDD18C222C0A09090909090922D0BBD18ED182D0B8D0B9222C0A09090909090922D0B1D0B5D180D0B5D0B7D0B5D0BDD18C222C0A09090909090922D0BAD0B2D196D182D0B5D0BDD18C222C0A09090909090922D182D180D0B0D0B2D0B5D0BDD18C222C0A';
wwv_flow_api.g_varchar2_table(139) := '09090909090922D187D0B5D180D0B2D0B5D0BDD18C222C0A09090909090922D0BBD0B8D0BFD0B5D0BDD18C222C0A09090909090922D181D0B5D180D0BFD0B5D0BDD18C222C0A09090909090922D0B2D0B5D180D0B5D181D0B5D0BDD18C222C0A09090909';
wwv_flow_api.g_varchar2_table(140) := '090922D0B6D0BED0B2D182D0B5D0BDD18C222C0A09090909090922D0BBD0B8D181D182D0BED0BFD0B0D0B4222C0A09090909090922D0B3D180D183D0B4D0B5D0BDD18C220A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A';
wwv_flow_api.g_varchar2_table(141) := '090909090973686F7274203A205B0A09090909090927D0BD272C0A09090909090927D0BF272C0A09090909090927D0B2272C0A09090909090927D181272C0A09090909090927D187272C0A09090909090927D0BF272C0A09090909090927D181270A0909';
wwv_flow_api.g_varchar2_table(142) := '0909095D2C0A090909090966756C6C203A205B0A09090909090927D0BDD0B5D0B4D196D0BBD18F272C0A09090909090927D0BFD0BED0BDD0B5D0B4D196D0BBD0BED0BA272C0A09090909090927D0B2D196D0B2D182D0BED180D0BED0BA272C0A09090909';
wwv_flow_api.g_varchar2_table(143) := '090927D181D0B5D180D0B5D0B4D0B0272C0A09090909090927D187D0B5D182D0B2D0B5D180272C0A09090909090927D0BF5C27D18FD182D0BDD0B8D186D18F272C0A09090909090927D181D183D0B1D0BED182D0B0270A09090909095D0A090909097D0A';
wwv_flow_api.g_varchar2_table(144) := '0909097D2C0A09090927727527203A207B0A090909096E616D65203A2027D180D183D181D181D0BAD0B8D0B920D18FD0B7D18BD0BA272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A09090909097368';
wwv_flow_api.g_varchar2_table(145) := '6F72743A205B0A09090909090922D18FD0BDD0B2D0B0D180D18C222C0A09090909090922D184D0B5D0B2D180D0B0D0BBD18C222C0A09090909090922D0BCD0B0D180D182222C0A09090909090922D0B0D0BFD180D0B5D0BBD18C222C0A09090909090922';
wwv_flow_api.g_varchar2_table(146) := 'D0BCD0B0D0B9222C0A09090909090922D0B8D18ED0BDD18C222C0A09090909090922D0B8D18ED0BBD18C222C0A09090909090922D0B0D0B2D0B3D183D181D182222C0A09090909090922D181D0B5D0BDD182D18FD0B1D180D18C222C0A09090909090922';
wwv_flow_api.g_varchar2_table(147) := 'D0BED0BAD182D18FD0B1D180D18C222C0A09090909090922D0BDD0BED18FD0B1D180D18C222C0A09090909090922D0B4D0B5D0BAD0B0D0B1D180D18C220A09090909095D2C0A090909090966756C6C203A205B0A09090909090922D18FD0BDD0B2D0B0D1';
wwv_flow_api.g_varchar2_table(148) := '80D18C222C0A09090909090922D184D0B5D0B2D180D0B0D0BBD18C222C0A09090909090922D0BCD0B0D180D182222C0A09090909090922D0B0D0BFD180D0B5D0BBD18C222C0A09090909090922D0BCD0B0D0B9222C0A09090909090922D0B8D18ED0BDD1';
wwv_flow_api.g_varchar2_table(149) := '8C222C0A09090909090922D0B8D18ED0BBD18C222C0A09090909090922D0B0D0B2D0B3D183D181D182222C0A09090909090922D181D0B5D0BDD182D18FD0B1D180D18C222C0A09090909090922D0BED0BAD182D18FD0B1D180D18C222C0A090909090909';
wwv_flow_api.g_varchar2_table(150) := '22D0BDD0BED18FD0B1D180D18C222C0A09090909090922D0B4D0B5D0BAD0B0D0B1D180D18C220A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A09090909090927D0B2272C0A090909';
wwv_flow_api.g_varchar2_table(151) := '09090927D0BF272C0A09090909090927D0B2272C0A09090909090927D181272C0A09090909090927D187272C0A09090909090927D0BF272C0A09090909090927D181270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927D0B2D0';
wwv_flow_api.g_varchar2_table(152) := 'BED181D0BAD180D0B5D181D0B5D0BDD18CD0B5272C0A09090909090927D0BFD0BED0BDD0B5D0B4D0B5D0BBD18CD0BDD0B8D0BA272C0A09090909090927D0B2D182D0BED180D0BDD0B8D0BA272C0A09090909090927D181D180D0B5D0B4D0B0272C0A0909';
wwv_flow_api.g_varchar2_table(153) := '0909090927D187D0B5D182D0B2D0B5D180D0B3272C0A09090909090927D0BFD18FD182D0BDD0B8D186D0B0272C0A09090909090927D181D183D0B1D0B1D0BED182D0B0270A09090909095D0A090909097D0A0909097D2C0A09090927747227203A207B0A';
wwv_flow_api.g_varchar2_table(154) := '090909096E616D65203A202754C3BC726BC3A765272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A090909090909224F6361222C0A09090909090922C59E7562222C';
wwv_flow_api.g_varchar2_table(155) := '0A090909090909224D6172222C0A090909090909224E6973222C0A090909090909224D6179222C0A0909090909092248617A222C0A0909090909092254656D222C0A0909090909092241C49F75222C0A0909090909092245796C222C0A09090909090922';
wwv_flow_api.g_varchar2_table(156) := '456B69222C0A090909090909224B6173222C0A09090909090922417261220A09090909095D2C0A090909090966756C6C203A205B0A090909090909224F63616B222C0A09090909090922C59E75626174222C0A090909090909224D617274222C0A090909';
wwv_flow_api.g_varchar2_table(157) := '090909224E6973616E222C0A090909090909224D6179C4B173222C0A0909090909092248617A6972616E222C0A0909090909092254656D6D757A222C0A0909090909092241C49F7573746F73222C0A0909090909092245796CC3BC6C222C0A0909090909';
wwv_flow_api.g_varchar2_table(158) := '0922456B696D222C0A090909090909224B6173C4B16D222C0A090909090909224172616CC4B16B220A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973686F7274203A205B0A0909090909092750272C0A0909';
wwv_flow_api.g_varchar2_table(159) := '090909092750272C0A0909090909092753272C0A09090909090927C387272C0A0909090909092750272C0A0909090909092743272C0A0909090909092743270A09090909095D2C0A090909090966756C6C203A205B0A0909090909092750617A6172272C';
wwv_flow_api.g_varchar2_table(160) := '0A0909090909092750617A617274657369272C0A0909090909092753616C69272C0A09090909090927C3876172C59F616D6261272C0A09090909090927506572C59F656D6265272C0A0909090909092743756D61272C0A0909090909092743756D617274';
wwv_flow_api.g_varchar2_table(161) := '657369270A09090909095D0A090909097D0A0909097D2C0A090909276B6F27203A207B0A090909096E616D65203A2027ECA1B0EC84A0EBA790272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909';
wwv_flow_api.g_varchar2_table(162) := '090973686F72743A205B0A0909090909092231EC9B94222C0A0909090909092232EC9B94222C0A0909090909092233EC9B94222C0A0909090909092234EC9B94222C0A0909090909092235EC9B94222C0A0909090909092236EC9B94222C0A0909090909';
wwv_flow_api.g_varchar2_table(163) := '092237EC9B94222C0A0909090909092238EC9B94222C0A0909090909092239EC9B94222C0A090909090909223130EC9B94222C0A090909090909223131EC9B94222C0A090909090909223132EC9B94220A09090909095D2C0A090909090966756C6C203A';
wwv_flow_api.g_varchar2_table(164) := '205B0A0909090909092231EC9B94222C0A0909090909092232EC9B94222C0A0909090909092233EC9B94222C0A0909090909092234EC9B94222C0A0909090909092235EC9B94222C0A0909090909092236EC9B94222C0A0909090909092237EC9B94222C';
wwv_flow_api.g_varchar2_table(165) := '0A0909090909092238EC9B94222C0A0909090909092239EC9B94222C0A090909090909223130EC9B94222C0A090909090909223131EC9B94222C0A090909090909223132EC9B94220A09090909095D0A090909097D2C0A090909097765656B6461797320';
wwv_flow_api.g_varchar2_table(166) := '3A207B0A090909090973686F7274203A205B0A09090909090927EC9DBC272C0A09090909090927EC9B94272C0A09090909090927ED9994272C0A09090909090927EC8898272C0A09090909090927EBAAA9272C0A09090909090927EAB888272C0A090909';
wwv_flow_api.g_varchar2_table(167) := '09090927ED86A0270A09090909095D2C0A090909090966756C6C203A205B0A09090909090927EC9DBCEC9A94EC9DBC272C0A09090909090927EC9B94EC9A94EC9DBC272C0A09090909090927ED9994EC9A94EC9DBC272C0A09090909090927EC8898EC9A';
wwv_flow_api.g_varchar2_table(168) := '94EC9DBC272C0A09090909090927EBAAA9EC9A94EC9DBC272C0A09090909090927EAB888EC9A94EC9DBC272C0A09090909090927ED86A0EC9A94EC9DBC270A09090909095D0A090909097D0A0909097D2C0A09090927666927203A207B0A090909096E61';
wwv_flow_api.g_varchar2_table(169) := '6D65203A202773756F6D656E206B69656C69272C0A09090909677265676F7269616E203A20747275652C0A090909096D6F6E746873203A207B0A090909090973686F72743A205B0A0909090909092254616D222C0A0909090909092248656C222C0A0909';
wwv_flow_api.g_varchar2_table(170) := '09090909224D6161222C0A09090909090922487568222C0A09090909090922546F75222C0A090909090909224B6573222C0A09090909090922486569222C0A09090909090922456C6F222C0A09090909090922537979222C0A090909090909224C6F6B22';
wwv_flow_api.g_varchar2_table(171) := '2C0A090909090909224D6172222C0A090909090909224A6F75220A09090909095D2C0A090909090966756C6C203A205B0A0909090909092254616D6D696B7575222C0A0909090909092248656C6D696B7575222C0A090909090909224D61616C69736B75';
wwv_flow_api.g_varchar2_table(172) := '75222C0A0909090909092248756874696B7575222C0A09090909090922546F756B6F6B7575222C0A090909090909224B6573C3A46B7575222C0A090909090909224865696EC3A46B7575222C0A09090909090922456C6F6B7575222C0A09090909090922';
wwv_flow_api.g_varchar2_table(173) := '537979736B7575222C0A090909090909224C6F6B616B7575222C0A090909090909224D61727261736B7575222C0A090909090909224A6F756C756B7575220A09090909095D0A090909097D2C0A090909097765656B64617973203A207B0A090909090973';
wwv_flow_api.g_varchar2_table(174) := '686F7274203A205B0A0909090909092753272C0A090909090909274D272C0A0909090909092754272C0A090909090909274B272C0A0909090909092754272C0A0909090909092750272C0A090909090909274C270A09090909095D2C0A09090909096675';
wwv_flow_api.g_varchar2_table(175) := '6C6C203A205B0A0909090909092753756E6E756E746169272C0A090909090909274D61616E616E746169272C0A0909090909092754696973746169272C0A090909090909274B65736B697669696B6B6F272C0A09090909090927546F7273746169272C0A';
wwv_flow_api.g_varchar2_table(176) := '090909090909275065726A616E746169272C0A090909090909274C6175616E746169270A09090909095D0A090909097D0A0909097D2C0A090909277669273A7B0A090909096E616D653A275469E1BABF6E67207669E1BB8774272C0A0909090967726567';
wwv_flow_api.g_varchar2_table(177) := '6F7269616E3A66616C73652C0A090909096D6F6E7468733A7B0A090909090973686F72743A5B0A0909090909092754682E3031272C0A0909090909092754682E3032272C0A0909090909092754682E3033272C0A0909090909092754682E3034272C0A09';
wwv_flow_api.g_varchar2_table(178) := '09090909092754682E3035272C0A0909090909092754682E3036272C0A0909090909092754682E3037272C0A0909090909092754682E3038272C0A0909090909092754682E3039272C0A0909090909092754682E3130272C0A0909090909092754682E31';
wwv_flow_api.g_varchar2_table(179) := '31272C0A0909090909092754682E3132270A09090909095D2C0A090909090966756C6C3A5B0A090909090909275468C3A16E67203031272C0A090909090909275468C3A16E67203032272C0A090909090909275468C3A16E67203033272C0A0909090909';
wwv_flow_api.g_varchar2_table(180) := '09275468C3A16E67203034272C0A090909090909275468C3A16E67203035272C0A090909090909275468C3A16E67203036272C0A090909090909275468C3A16E67203037272C0A090909090909275468C3A16E67203038272C0A090909090909275468C3';
wwv_flow_api.g_varchar2_table(181) := 'A16E67203039272C0A090909090909275468C3A16E67203130272C0A090909090909275468C3A16E67203131272C0A090909090909275468C3A16E67203132270A09090909095D0A090909097D2C0A090909097765656B646179733A7B0A090909090973';
wwv_flow_api.g_varchar2_table(182) := '686F72743A5B0A09090909090927434E272C0A090909090909275432272C0A090909090909275433272C0A090909090909275434272C0A090909090909275435272C0A090909090909275436272C0A090909090909275437270A09090909095D2C0A0909';
wwv_flow_api.g_varchar2_table(183) := '09090966756C6C3A5B0A090909090909274368E1BBA7206E68E1BAAD74272C0A090909090909275468E1BBA920686169272C0A090909090909275468E1BBA9206261272C0A090909090909275468E1BBA92074C6B0272C0A090909090909275468E1BBA9';
wwv_flow_api.g_varchar2_table(184) := '206EC4836D272C0A090909090909275468E1BBA92073C3A175272C0A090909090909275468E1BBA92062E1BAA379270A09090909095D0A090909097D0A0909097D0A09097D2C0A0A09092F2F204D41494E20564152530A0A09097069636B657273203D20';
wwv_flow_api.g_varchar2_table(185) := '7B7D2C0A09097069636B6572203D206E756C6C2C0A09097069636B65725F6374726C203D2066616C73652C0A09097069636B5F64726167676564203D206E756C6C2C0A09097069636B5F647261675F6F6666736574203D206E756C6C2C0A09097069636B';
wwv_flow_api.g_varchar2_table(186) := '5F647261675F74656D70203D206E756C6C2C0A0A09092F2F20434845434B2046554E4354494F4E530A0A090969735F636C69636B203D2066616C73652C0A090969735F6965203D2066756E6374696F6E2829207B0A0909097661720A090909096E203D20';
wwv_flow_api.g_varchar2_table(187) := '6E6176696761746F722E757365724167656E742E746F4C6F7765724361736528293B0A09090972657475726E20286E2E696E6465784F6628276D736965272920213D202D3129203F207061727365496E74286E2E73706C697428276D73696527295B315D';
wwv_flow_api.g_varchar2_table(188) := '29203A2066616C73653B0A09097D2C0A090969735F746F756368203D2066756E6374696F6E2829207B0A0909096966282F416E64726F69647C7765624F537C6950686F6E657C695061647C69506F647C426C61636B42657272797C49454D6F62696C657C';
wwv_flow_api.g_varchar2_table(189) := '4F70657261204D696E692F692E74657374286E6176696761746F722E757365724167656E7429290A0909090972657475726E20747275653B0A090909656C73650A0909090972657475726E2066616C73653B0A09097D2C0A090969735F66785F6D6F6269';
wwv_flow_api.g_varchar2_table(190) := '6C65203D2066756E6374696F6E2829207B0A0909096966287069636B657226267069636B6572735B7069636B65722E69645D2E66782626217069636B6572735B7069636B65722E69645D2E66786D6F62696C6529207B0A09090909696628242877696E64';
wwv_flow_api.g_varchar2_table(191) := '6F77292E776964746828293C343830290A09090909097069636B65722E656C656D656E742E72656D6F7665436C61737328277069636B65722D66787327293B0A09090909656C73650A09090909097069636B65722E656C656D656E742E616464436C6173';
wwv_flow_api.g_varchar2_table(192) := '7328277069636B65722D66787327290A0909097D0A09097D2C0A090969735F6A756D7061626C65203D2066756E6374696F6E2829207B0A090909696628207069636B6572735B7069636B65722E69645D2E6A756D70203E3D207069636B6572735B706963';
wwv_flow_api.g_varchar2_table(193) := '6B65722E69645D2E6B65792E792E6D6178202D207069636B6572735B7069636B65722E69645D2E6B65792E792E6D696E20290A0909090972657475726E2066616C73653B0A090909656C73650A0909090972657475726E20747275653B0A09097D2C0A09';
wwv_flow_api.g_varchar2_table(194) := '0969735F6C6F636B6564203D2066756E6374696F6E2829207B0A0909097661720A09090909756E69785F63757272656E74203D206765745F756E6978286765745F63757272656E745F66756C6C2829292C0A09090909756E69785F746F646179203D2067';
wwv_flow_api.g_varchar2_table(195) := '65745F756E6978286765745F746F6461795F66756C6C2829293B0A0A0909096966287069636B6572735B7069636B65722E69645D2E6C6F636B29207B0A090909096966287069636B6572735B7069636B65722E69645D2E6C6F636B3D3D2766726F6D2729';
wwv_flow_api.g_varchar2_table(196) := '207B0A0909090909696628756E69785F63757272656E743C756E69785F746F64617929207B0A0909090909097069636B65725F616C727428293B0A0909090909097069636B65722E656C656D656E742E616464436C61737328277069636B65722D6C6B64';
wwv_flow_api.g_varchar2_table(197) := '27293B0A09090909090972657475726E20747275653B0A09090909097D0A0909090909656C7365207B0A0909090909097069636B65722E656C656D656E742E72656D6F7665436C61737328277069636B65722D6C6B6427293B0A09090909090972657475';
wwv_flow_api.g_varchar2_table(198) := '726E2066616C73653B0A09090909097D0A090909097D0A090909096966287069636B6572735B7069636B65722E69645D2E6C6F636B3D3D27746F2729207B0A0909090909696628756E69785F63757272656E743E756E69785F746F64617929207B0A0909';
wwv_flow_api.g_varchar2_table(199) := '090909097069636B65725F616C727428293B0A0909090909097069636B65722E656C656D656E742E616464436C61737328277069636B65722D6C6B6427293B0A09090909090972657475726E20747275653B0A09090909097D0A0909090909656C736520';
wwv_flow_api.g_varchar2_table(200) := '7B0A0909090909097069636B65722E656C656D656E742E72656D6F7665436C61737328277069636B65722D6C6B6427293B0A09090909090972657475726E2066616C73653B0A09090909097D0A090909097D0A0909097D0A0A0909096966287069636B65';
wwv_flow_api.g_varchar2_table(201) := '72735B7069636B65722E69645D2E64697361626C656461797329207B0A090909096966287069636B6572735B7069636B65722E69645D2E64697361626C65646179732E696E6465784F6628756E69785F63757272656E742920213D202D3129207B0A0909';
wwv_flow_api.g_varchar2_table(202) := '0909097069636B65725F616C727428293B0A09090909097069636B65722E656C656D656E742E616464436C61737328277069636B65722D6C6B6427293B0A090909090972657475726E20747275653B0A090909097D0A09090909656C7365207B0A090909';
wwv_flow_api.g_varchar2_table(203) := '09097069636B65722E656C656D656E742E72656D6F7665436C61737328277069636B65722D6C6B6427293B0A090909090972657475726E2066616C73653B0A090909097D0A0909097D0A09097D2C0A090969735F696E74203D2066756E6374696F6E286E';
wwv_flow_api.g_varchar2_table(204) := '29207B0A09090972657475726E206E20252031203D3D3D20303B0A09097D2C0A090969735F64617465203D2066756E6374696F6E2876616C756529207B0A0909097661720A09090909666F726D6174203D202F285E5C647B312C347D5B5C2E7C5C5C2F7C';
wwv_flow_api.g_varchar2_table(205) := '2D5D5C647B312C327D5B5C2E7C5C5C2F7C2D5D5C647B312C347D29285C732A283F3A303F5B312D395D3A5B302D355D7C31283F3D5B3031325D295C643A5B302D355D295C645C732A5B61705D6D293F242F3B0A09090972657475726E20666F726D61742E';
wwv_flow_api.g_varchar2_table(206) := '746573742876616C7565293B0A09097D2C0A0A09092F2F20524553542046554E4354494F4E530A0A09096765745F63757272656E74203D2066756E6374696F6E286B297B0A09090972657475726E207061727365496E74287069636B6572735B7069636B';
wwv_flow_api.g_varchar2_table(207) := '65722E69645D2E6B65795B6B5D2E63757272656E74293B0A09097D2C0A09096765745F746F646179203D2066756E6374696F6E286B297B0A09090972657475726E207061727365496E74287069636B6572735B7069636B65722E69645D2E6B65795B6B5D';
wwv_flow_api.g_varchar2_table(208) := '2E746F646179293B0A09097D2C0A09096765745F746F6461795F66756C6C203D2066756E6374696F6E2829207B0A09090972657475726E206765745F746F64617928276D27292B272F272B6765745F746F64617928276427292B272F272B6765745F746F';
wwv_flow_api.g_varchar2_table(209) := '64617928277927293B0A09097D2C0A09096765745F63757272656E745F66756C6C203D2066756E6374696F6E2829207B0A09090972657475726E206765745F63757272656E7428276D27292B272F272B6765745F63757272656E7428276427292B272F27';
wwv_flow_api.g_varchar2_table(210) := '2B6765745F63757272656E7428277927293B0A09097D2C0A09096765745F6A756D706564203D2066756E6374696F6E286B2C76616C29207B0A0909097661720A0909090961203D205B5D2C0A090909096B65795F76616C756573203D207069636B657273';
wwv_flow_api.g_varchar2_table(211) := '5B7069636B65722E69645D2E6B65795B6B5D3B0A090909666F7220287661722069203D206B65795F76616C7565732E6D696E3B2069203C3D206B65795F76616C7565732E6D61783B20692B2B290A0909090969662028692576616C203D3D2030290A0909';
wwv_flow_api.g_varchar2_table(212) := '090909612E707573682869293B0A09090972657475726E20613B0A09097D2C0A09096765745F636C6F736573745F6A756D706564203D2066756E6374696F6E28696E742C61727229207B0A0909097661722063203D206172725B305D3B0A090909766172';
wwv_flow_api.g_varchar2_table(213) := '2064203D204D6174682E6162732028696E74202D2063293B0A090909666F7220287661722069203D20303B2069203C206172722E6C656E6774683B20692B2B29207B0A09090909766172206E203D204D6174682E6162732028696E74202D206172725B69';
wwv_flow_api.g_varchar2_table(214) := '5D293B0A09090909696620286E203C206429207B0A090909090964203D206E3B0A090909090963203D206172725B695D3B0A090909097D0A0909097D0A09090972657475726E20633B0A09097D2C0A09096765745F636C656172203D2066756E6374696F';
wwv_flow_api.g_varchar2_table(215) := '6E286B2C6E297B0A0909097661720A090909096B65795F76616C756573203D207069636B6572735B7069636B65722E69645D2E6B65795B6B5D3B0A090909696628206E203E206B65795F76616C7565732E6D617820290A0909090972657475726E206765';
wwv_flow_api.g_varchar2_table(216) := '745F636C65617228206B202C20286E2D6B65795F76616C7565732E6D6178292B286B65795F76616C7565732E6D696E2D312920293B0A090909656C736520696628206E203C206B65795F76616C7565732E6D696E20290A0909090972657475726E206765';
wwv_flow_api.g_varchar2_table(217) := '745F636C65617228206B202C20286E2B3129202B20286B65795F76616C7565732E6D6178202D206B65795F76616C7565732E6D696E29293B0A090909656C73650A0909090972657475726E206E3B0A09097D2C0A09096765745F646179735F6172726179';
wwv_flow_api.g_varchar2_table(218) := '203D2066756E6374696F6E2829207B0A0909096966286931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E677265676F7269616E290A0909090972657475726E205B312C322C332C342C352C362C305D3B0A090909656C73650A09';
wwv_flow_api.g_varchar2_table(219) := '09090972657475726E205B302C312C322C332C342C352C365D3B0A09097D2C0A09096765745F756C203D2066756E6374696F6E286B29207B0A09090972657475726E206765745F7069636B65725F656C732827756C2E7069636B5B646174612D6B3D2227';
wwv_flow_api.g_varchar2_table(220) := '2B6B2B27225D27293B0A09097D2C0A09096765745F6571203D2066756E6374696F6E286B2C6429207B0A090909756C203D206765745F756C286B293B0A0909097661720A090909096F203D205B5D3B0A0A090909756C2E66696E6428276C6927292E6561';
wwv_flow_api.g_varchar2_table(221) := '63682866756E6374696F6E28297B0A090909096F2E7075736828242874686973292E61747472282776616C75652729293B0A0909097D293B0A0A090909696628643D3D276C61737427290A0909090972657475726E206F5B6F2E6C656E6774682D315D3B';
wwv_flow_api.g_varchar2_table(222) := '0A090909656C73650A0909090972657475726E206F5B305D3B0A0A09097D2C0A09096765745F7069636B65725F656C73203D2066756E6374696F6E28656C29207B0A0909096966287069636B6572290A0909090972657475726E207069636B65722E656C';
wwv_flow_api.g_varchar2_table(223) := '656D656E742E66696E6428656C293B0A09097D2C0A09096765745F756E6978203D2066756E6374696F6E286429207B0A09090972657475726E20446174652E7061727365286429202F20313030303B0A09097D2C0A0A09092F2F2052454E444552204655';
wwv_flow_api.g_varchar2_table(224) := '4E4354494F4E530A0A09097069636B65725F6C617267655F6F6E6F6666203D2066756E6374696F6E2829207B0A0909096966287069636B6572735B7069636B65722E69645D2E6C6172676529207B0A090909097069636B65722E656C656D656E742E746F';
wwv_flow_api.g_varchar2_table(225) := '67676C65436C61737328277069636B65722D6C6727293B0A090909097069636B65725F72656E6465725F63616C656E64617228293B0A0909097D0A09097D2C0A09097069636B65725F7472616E736C6174655F6F6E6F6666203D2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(226) := '29207B0A0909096765745F7069636B65725F656C732827756C2E7069636B2E7069636B2D6C27292E746F67676C65436C617373282776697369626C6527293B0A09097D2C0A09097069636B65725F6F6666736574203D2066756E6374696F6E28297B0A09';
wwv_flow_api.g_varchar2_table(227) := '0909696628217069636B65722E656C656D656E742E686173436C61737328277069636B65722D6D6F64616C2729297B0A090909097661720A0909090909696E707574203D207069636B65722E696E7075742C0A09090909096C656674203D20696E707574';
wwv_flow_api.g_varchar2_table(228) := '2E6F666673657428292E6C656674202B20696E7075742E6F75746572576964746828292F322C0A0909090909746F70203D20696E7075742E6F666673657428292E746F70202B20696E7075742E6F7574657248656967687428293B0A090909097069636B';
wwv_flow_api.g_varchar2_table(229) := '65722E656C656D656E742E637373287B0A0909090909276C65667427203A206C6566742C0A090909090927746F7027203A20746F700A090909097D293B0A0909097D0A09097D2C0A09097069636B65725F7472616E736C617465203D2066756E6374696F';
wwv_flow_api.g_varchar2_table(230) := '6E287629207B0A0909097069636B6572735B7069636B65722E69645D2E6C616E67203D204F626A6563742E6B657973286931386E295B765D3B0A0909097069636B65725F7365745F6C616E6728293B0A0909097069636B65725F73657428293B0A09097D';
wwv_flow_api.g_varchar2_table(231) := '2C0A09097069636B65725F7365745F6C616E67203D2066756E6374696F6E2829207B0A0909097661720A090909097069636B65725F6461795F6F6666736574203D206765745F646179735F617272617928293B0A0909096765745F7069636B65725F656C';
wwv_flow_api.g_varchar2_table(232) := '7328272E7069636B2D6C67202E7069636B2D6C672D68206C6927292E656163682866756E6374696F6E2869297B0A09090909242874686973292E68746D6C286931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E7765656B646179';
wwv_flow_api.g_varchar2_table(233) := '732E73686F72745B7069636B65725F6461795F6F66667365745B695D5D293B0A0909097D293B0A0909096765745F7069636B65725F656C732827756C2E7069636B2E7069636B2D6D206C6927292E656163682866756E6374696F6E28297B0A0909090924';
wwv_flow_api.g_varchar2_table(234) := '2874686973292E68746D6C286931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E6D6F6E7468732E73686F72745B242874686973292E61747472282776616C756527292D315D293B0A0909097D293B0A09097D2C0A09097069636B';
wwv_flow_api.g_varchar2_table(235) := '65725F73686F77203D2066756E6374696F6E2829207B0A0909097069636B65722E656C656D656E742E616464436C61737328277069636B65722D666F63757327293B0A09097D2C0A09097069636B65725F68696465203D2066756E6374696F6E2829207B';
wwv_flow_api.g_varchar2_table(236) := '0A0909096966282169735F6C6F636B6564282929207B0A090909097069636B65722E656C656D656E742E72656D6F7665436C61737328277069636B65722D666F63757327293B0A090909096966287069636B65722E656C656D656E742E686173436C6173';
wwv_flow_api.g_varchar2_table(237) := '7328277069636B65722D6D6F64616C2729290A09090909092428272E7069636B65722D6D6F64616C2D6F7665726C617927292E616464436C6173732827746F6869646527293B0A090909097069636B6572203D206E756C6C3B0A0909097D0A0909097069';
wwv_flow_api.g_varchar2_table(238) := '636B65725F6374726C203D2066616C73653B0A09097D2C0A09097069636B65725F72656E6465725F756C203D2066756E6374696F6E286B297B0A0909097661720A09090909756C203D206765745F756C286B292C0A090909096B65795F76616C75657320';
wwv_flow_api.g_varchar2_table(239) := '3D207069636B6572735B7069636B65722E69645D2E6B65795B6B5D3B0A0A0909092F2F43555252454E542056414C55450A0909097069636B6572735B7069636B65722E69645D2E6B65795B6B5D2E63757272656E74203D206B65795F76616C7565732E74';
wwv_flow_api.g_varchar2_table(240) := '6F646179203C206B65795F76616C7565732E6D696E202626206B65795F76616C7565732E6D696E207C7C206B65795F76616C7565732E746F6461793B0A0A090909666F72202869203D206B65795F76616C7565732E6D696E3B2069203C3D206B65795F76';
wwv_flow_api.g_varchar2_table(241) := '616C7565732E6D61783B20692B2B29207B0A090909097661720A090909090968746D6C203D20693B0A0A090909096966286B3D3D276D27290A090909090968746D6C203D206931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E6D';
wwv_flow_api.g_varchar2_table(242) := '6F6E7468732E73686F72745B692D315D3B0A090909096966286B3D3D276C27290A090909090968746D6C203D206931386E5B4F626A6563742E6B657973286931386E295B695D5D2E6E616D653B0A0A0909090968746D6C202B3D206B3D3D276427203F20';
wwv_flow_api.g_varchar2_table(243) := '273C7370616E3E3C2F7370616E3E27203A2027273B0A0A090909092428273C6C693E272C207B0A090909090976616C75653A20692C0A090909090968746D6C3A2068746D6C0A090909097D290A090909092E617070656E64546F28756C290A0909097D0A';
wwv_flow_api.g_varchar2_table(244) := '0A0909092F2F5052455620425554544F4E0A0909092428273C6469763E272C207B0A09090909636C6173733A20277069636B2D617277207069636B2D6172772D7331207069636B2D6172772D6C272C0A0909090968746D6C3A202428273C693E272C207B';
wwv_flow_api.g_varchar2_table(245) := '0A0909090909636C6173733A20277069636B2D692D6C270A090909097D290A0909097D290A0909092E617070656E64546F28756C293B0A0A0909092F2F4E45585420425554544F4E0A0909092428273C6469763E272C207B0A09090909636C6173733A20';
wwv_flow_api.g_varchar2_table(246) := '277069636B2D617277207069636B2D6172772D7331207069636B2D6172772D72272C0A0909090968746D6C3A202428273C693E272C207B0A0909090909636C6173733A20277069636B2D692D72270A090909097D290A0909097D290A0909092E61707065';
wwv_flow_api.g_varchar2_table(247) := '6E64546F28756C293B0A0A0909096966286B3D3D27792729207B0A0A090909092F2F5052455620425554544F4E0A090909092428273C6469763E272C207B0A0909090909636C6173733A20277069636B2D617277207069636B2D6172772D733220706963';
wwv_flow_api.g_varchar2_table(248) := '6B2D6172772D6C272C0A090909090968746D6C3A202428273C693E272C207B0A090909090909636C6173733A20277069636B2D692D6C270A09090909097D290A090909097D290A090909092E617070656E64546F28756C293B0A0A090909092F2F4E4558';
wwv_flow_api.g_varchar2_table(249) := '5420425554544F4E0A090909092428273C6469763E272C207B0A0909090909636C6173733A20277069636B2D617277207069636B2D6172772D7332207069636B2D6172772D72272C0A090909090968746D6C3A202428273C693E272C207B0A0909090909';
wwv_flow_api.g_varchar2_table(250) := '09636C6173733A20277069636B2D692D72270A09090909097D290A090909097D290A090909092E617070656E64546F28756C293B0A0A0909097D0A0A0909097069636B65725F756C5F7472616E736974696F6E286B2C6765745F63757272656E74286B29';
wwv_flow_api.g_varchar2_table(251) := '293B0A0A09097D2C0A09097069636B65725F72656E6465725F63616C656E646172203D2066756E6374696F6E2829207B0A0A0909097661720A09090909696E646578203D20302C0A0909090977203D206765745F7069636B65725F656C7328272E706963';
wwv_flow_api.g_varchar2_table(252) := '6B2D6C672D6227293B0A0A090909772E66696E6428276C6927290A0909092E656D70747928290A0909092E72656D6F7665436C61737328277069636B2D6E207069636B2D62207069636B2D61207069636B2D76207069636B2D6C6B207069636B2D736C20';
wwv_flow_api.g_varchar2_table(253) := '7069636B2D6827290A0909092E617474722827646174612D76616C7565272C2727293B0A0A0909097661720A090909095F43203D206E65772044617465286765745F63757272656E745F66756C6C2829292C0A090909095F53203D206E65772044617465';
wwv_flow_api.g_varchar2_table(254) := '286765745F63757272656E745F66756C6C2829292C0A090909095F4C203D206E65772044617465286765745F63757272656E745F66756C6C2829292C0A090909095F4E554D203D2066756E6374696F6E2864297B0A09090909097661720A090909090909';
wwv_flow_api.g_varchar2_table(255) := '6D203D20642E6765744D6F6E746828292C0A09090909090979203D20642E67657446756C6C5965617228293B0A0909090909766172206C203D202828792025203429203D3D2030202626202828792025203130302920213D2030207C7C20287920252034';
wwv_flow_api.g_varchar2_table(256) := '303029203D3D203029293B0A090909090972657475726E205B33312C20286C203F203239203A203238292C2033312C2033302C2033312C2033302C2033312C2033312C2033302C2033312C2033302C2033315D5B6D5D3B0A090909097D3B0A0A0909095F';
wwv_flow_api.g_varchar2_table(257) := '4C2E7365744D6F6E7468285F4C2E6765744D6F6E746828292D31293B0A0909095F532E736574446174652831293B0A0A0909097661720A090909096F203D205F532E67657444617928292D313B0A090909096966286F3C30290A09090909096F203D2036';
wwv_flow_api.g_varchar2_table(258) := '3B0A090909096966286931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E677265676F7269616E29207B0A09090909096F2D2D3B0A09090909096966286F3C30290A0909090909096F3D363B0A090909097D0A0A0909092F2F6265';
wwv_flow_api.g_varchar2_table(259) := '666F72650A090909666F72287661722069203D205F4E554D285F4C292D6F203B2069203C3D205F4E554D285F4C29203B20692B2B29207B0A09090909772E66696E6428276C6927292E657128696E646578290A090909092E68746D6C2869290A09090909';
wwv_flow_api.g_varchar2_table(260) := '2E616464436C61737328277069636B2D62207069636B2D6E207069636B2D6827293B0A09090909696E6465782B2B3B0A0909097D0A0909092F2F63757272656E740A090909666F72287661722069203D2031203B2069203C3D205F4E554D285F5329203B';
wwv_flow_api.g_varchar2_table(261) := '20692B2B29207B0A09090909772E66696E6428276C6927292E657128696E646578290A090909092E68746D6C2869290A090909092E616464436C61737328277069636B2D6E207069636B2D7627290A090909092E617474722827646174612D76616C7565';
wwv_flow_api.g_varchar2_table(262) := '272C69293B0A09090909696E6465782B2B3B0A0909097D0A0909092F2F61667465720A090909696628772E66696E6428276C692E7069636B2D6E27292E6C656E677468203C20343229207B0A090909097661720A090909090965203D203432202D20772E';
wwv_flow_api.g_varchar2_table(263) := '66696E6428276C692E7069636B2D6E27292E6C656E6774683B0A09090909666F72287661722069203D2031203B2069203C3D20653B20692B2B29207B0A0909090909772E66696E6428276C6927292E657128696E646578292E68746D6C2869290A090909';
wwv_flow_api.g_varchar2_table(264) := '09092E616464436C61737328277069636B2D61207069636B2D6E207069636B2D6827293B0A0909090909696E6465782B2B3B0A090909097D0A0909097D0A0909096966287069636B6572735B7069636B65722E69645D2E6C6F636B29207B0A0909090969';
wwv_flow_api.g_varchar2_table(265) := '66287069636B6572735B7069636B65722E69645D2E6C6F636B3D3D3D2766726F6D2729207B0A09090909096966286765745F63757272656E7428277927293C3D6765745F746F646179282779272929207B0A0909090909096966286765745F6375727265';
wwv_flow_api.g_varchar2_table(266) := '6E7428276D27293D3D6765745F746F64617928276D272929207B0A090909090909096765745F7069636B65725F656C7328272E7069636B2D6C67202E7069636B2D6C672D62206C692E7069636B2D765B646174612D76616C75653D22272B6765745F746F';
wwv_flow_api.g_varchar2_table(267) := '64617928276427292B27225D27290A090909090909092E70726576416C6C28276C6927290A090909090909092E616464436C61737328277069636B2D6C6B27290A0909090909097D0A090909090909656C7365207B0A090909090909096966286765745F';
wwv_flow_api.g_varchar2_table(268) := '63757272656E7428276D27293C6765745F746F64617928276D272929207B0A09090909090909096765745F7069636B65725F656C7328272E7069636B2D6C67202E7069636B2D6C672D62206C6927290A09090909090909092E616464436C617373282770';
wwv_flow_api.g_varchar2_table(269) := '69636B2D6C6B27290A090909090909097D0A09090909090909656C7365206966286765745F63757272656E7428276D27293E6765745F746F64617928276D272926266765745F63757272656E7428277927293C6765745F746F646179282779272929207B';
wwv_flow_api.g_varchar2_table(270) := '0A09090909090909096765745F7069636B65725F656C7328272E7069636B2D6C67202E7069636B2D6C672D62206C6927290A09090909090909092E616464436C61737328277069636B2D6C6B27290A090909090909097D0A0909090909097D0A09090909';
wwv_flow_api.g_varchar2_table(271) := '097D0A090909097D0A09090909656C7365207B0A09090909096966286765745F63757272656E7428277927293E3D6765745F746F646179282779272929207B0A0909090909096966286765745F63757272656E7428276D27293D3D6765745F746F646179';
wwv_flow_api.g_varchar2_table(272) := '28276D272929207B0A090909090909096765745F7069636B65725F656C7328272E7069636B2D6C67202E7069636B2D6C672D62206C692E7069636B2D765B646174612D76616C75653D22272B6765745F746F64617928276427292B27225D27290A090909';
wwv_flow_api.g_varchar2_table(273) := '090909092E6E657874416C6C28276C6927290A090909090909092E616464436C61737328277069636B2D6C6B27290A0909090909097D0A090909090909656C7365207B0A090909090909096966286765745F63757272656E7428276D27293E6765745F74';
wwv_flow_api.g_varchar2_table(274) := '6F64617928276D272929207B0A09090909090909096765745F7069636B65725F656C7328272E7069636B2D6C67202E7069636B2D6C672D62206C6927290A09090909090909092E616464436C61737328277069636B2D6C6B27290A090909090909097D0A';
wwv_flow_api.g_varchar2_table(275) := '09090909090909656C7365206966286765745F63757272656E7428276D27293C6765745F746F64617928276D272926266765745F63757272656E7428277927293E6765745F746F646179282779272929207B0A09090909090909096765745F7069636B65';
wwv_flow_api.g_varchar2_table(276) := '725F656C7328272E7069636B2D6C67202E7069636B2D6C672D62206C6927290A09090909090909092E616464436C61737328277069636B2D6C6B27290A090909090909097D0A0909090909097D0A09090909097D0A090909097D0A0909097D0A09090969';
wwv_flow_api.g_varchar2_table(277) := '66287069636B6572735B7069636B65722E69645D2E64697361626C656461797329207B0A09090909242E65616368287069636B6572735B7069636B65722E69645D2E64697361626C65646179732C2066756E6374696F6E2820692C20762029207B0A0909';
wwv_flow_api.g_varchar2_table(278) := '09090969662876262669735F6461746528762929207B0A0909090909097661720A0909090909090964203D206E6577204461746528762A31303030293B0A090909090909696628642E6765744D6F6E746828292B313D3D6765745F63757272656E742827';
wwv_flow_api.g_varchar2_table(279) := '6D27292626642E67657446756C6C5965617228293D3D6765745F63757272656E742827792729290A090909090909096765745F7069636B65725F656C7328272E7069636B2D6C67202E7069636B2D6C672D62206C692E7069636B2D765B646174612D7661';
wwv_flow_api.g_varchar2_table(280) := '6C75653D22272B642E6765744461746528292B27225D27290A090909090909092E616464436C61737328277069636B2D6C6B27293B0A09090909097D0A090909097D293B0A0909097D0A0A0909096765745F7069636B65725F656C7328272E7069636B2D';
wwv_flow_api.g_varchar2_table(281) := '6C672D62206C692E7069636B2D765B646174612D76616C75653D272B6765745F63757272656E7428276427292B275D27292E616464436C61737328277069636B2D736C27293B0A0A09097D2C0A09097069636B65725F66696C6C73203D2066756E637469';
wwv_flow_api.g_varchar2_table(282) := '6F6E2829207B0A0A0909097661720A090909096D203D206765745F63757272656E7428276D27292C0A0909090979203D206765745F63757272656E7428277927292C0A090909096C203D202828792025203429203D3D2030202626202828792025203130';
wwv_flow_api.g_varchar2_table(283) := '302920213D2030207C7C20287920252034303029203D3D203029293B0A0A0909097069636B6572735B7069636B65722E69645D2E6B65795B2764275D2E6D6178203D20205B33312C20286C203F203239203A203238292C2033312C2033302C2033312C20';
wwv_flow_api.g_varchar2_table(284) := '33302C2033312C2033312C2033302C2033312C2033302C2033315D5B6D2D315D3B0A0A0909096966286765745F63757272656E7428276427293E7069636B6572735B7069636B65722E69645D2E6B65795B2764275D2E6D617829207B0A09090909706963';
wwv_flow_api.g_varchar2_table(285) := '6B6572735B7069636B65722E69645D2E6B65795B2764275D2E63757272656E74203D207069636B6572735B7069636B65722E69645D2E6B65795B2764275D2E6D61783B0A090909097069636B65725F756C5F7472616E736974696F6E282764272C676574';
wwv_flow_api.g_varchar2_table(286) := '5F63757272656E742827642729293B0A0909097D0A0A0909096765745F7069636B65725F656C7328272E7069636B2D64206C6927290A0909092E72656D6F7665436C61737328277069636B2D776B6527290A0909092E656163682866756E6374696F6E28';
wwv_flow_api.g_varchar2_table(287) := '29207B0A090909097661720A090909090964203D206E65772044617465286D2B222F222B242874686973292E61747472282776616C756527292B222F222B79292E67657444617928293B0A0A09090909242874686973290A090909092E66696E64282773';
wwv_flow_api.g_varchar2_table(288) := '70616E27290A090909092E68746D6C286931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E7765656B646179732E66756C6C5B645D293B0A0A09090909696628643D3D307C7C643D3D36290A0909090909242874686973292E6164';
wwv_flow_api.g_varchar2_table(289) := '64436C61737328277069636B2D776B6527293B0A0A0909097D293B0A0A0909096966287069636B65722E656C656D656E742E686173436C61737328277069636B65722D6C67272929207B0A090909096765745F7069636B65725F656C7328272E7069636B';
wwv_flow_api.g_varchar2_table(290) := '2D6C672D62206C6927292E72656D6F7665436C61737328277069636B2D776B6527293B0A090909096765745F7069636B65725F656C7328272E7069636B2D6C672D62206C692E7069636B2D7627290A090909092E656163682866756E6374696F6E282920';
wwv_flow_api.g_varchar2_table(291) := '7B0A09090909097661720A09090909090964203D206E65772044617465286D2B222F222B242874686973292E617474722827646174612D76616C756527292B222F222B79292E67657444617928293B0A0909090909696628643D3D307C7C643D3D36290A';
wwv_flow_api.g_varchar2_table(292) := '090909090909242874686973292E616464436C61737328277069636B2D776B6527293B0A0A090909097D293B0A0909097D0A0A09097D2C0A09097069636B65725F736574203D2066756E6374696F6E2829207B0A0909096966287069636B65722E656C65';
wwv_flow_api.g_varchar2_table(293) := '6D656E742E686173436C61737328277069636B65722D6C672729290A090909097069636B65725F72656E6465725F63616C656E64617228293B0A0909097069636B65725F66696C6C7328293B0A090909696E7075745F6368616E67655F76616C75652829';
wwv_flow_api.g_varchar2_table(294) := '3B0A09097D2C0A0A09092F2F20414354494F4E2046554E4354494F4E530A0A09097069636B65725F756C5F7472616E736974696F6E203D2066756E6374696F6E286B2C6929207B0A0A0909097661720A09090909756C203D206765745F756C286B293B0A';
wwv_flow_api.g_varchar2_table(295) := '0A090909756C2E66696E6428276C6927292E72656D6F7665436C61737328277069636B2D736C207069636B2D626672207069636B2D61667227293B0A0A090909696628693D3D6765745F6571286B2C276C617374272929207B0A09090909766172206C69';
wwv_flow_api.g_varchar2_table(296) := '203D20756C2E66696E6428276C695B76616C75653D22272B6765745F6571286B2C27666972737427292B27225D27293B0A090909096C692E636C6F6E6528292E696E73657274416674657228756C2E66696E6428276C695B76616C75653D272B692B275D';
wwv_flow_api.g_varchar2_table(297) := '2729293B0A090909096C692E72656D6F766528293B0A0909097D0A090909696628693D3D6765745F6571286B2C276669727374272929207B0A09090909766172206C69203D20756C2E66696E6428276C695B76616C75653D22272B6765745F6571286B2C';
wwv_flow_api.g_varchar2_table(298) := '276C61737427292B27225D27293B0A090909096C692E636C6F6E6528292E696E736572744265666F726528756C2E66696E6428276C695B76616C75653D272B692B275D2729293B0A090909096C692E72656D6F766528293B0A0909097D0A0A090909756C';
wwv_flow_api.g_varchar2_table(299) := '2E66696E6428276C695B76616C75653D272B692B275D27292E616464436C61737328277069636B2D736C27293B0A090909756C2E66696E6428276C692E7069636B2D736C27292E6E657874416C6C28276C6927292E616464436C61737328277069636B2D';
wwv_flow_api.g_varchar2_table(300) := '61667227293B0A090909756C2E66696E6428276C692E7069636B2D736C27292E70726576416C6C28276C6927292E616464436C61737328277069636B2D62667227293B0A0A09097D2C0A09097069636B65725F76616C7565735F696E637265617365203D';
wwv_flow_api.g_varchar2_table(301) := '2066756E6374696F6E286B2C7629207B0A0A0909097661720A090909096B65795F76616C756573203D207069636B6572735B7069636B65722E69645D2E6B65795B6B5D3B0A0A090909696628763E6B65795F76616C7565732E6D617829207B0A09090909';
wwv_flow_api.g_varchar2_table(302) := '6966286B3D3D276427290A09090909097069636B65725F756C5F7475726E28276D272C27726967687427293B0A090909096966286B3D3D276D27290A09090909097069636B65725F756C5F7475726E282779272C27726967687427293B0A090909097620';
wwv_flow_api.g_varchar2_table(303) := '3D206B65795F76616C7565732E6D696E3B0A0909097D0A090909696628763C6B65795F76616C7565732E6D696E29207B0A090909096966286B3D3D276427290A09090909097069636B65725F756C5F7475726E28276D272C276C65667427293B0A090909';
wwv_flow_api.g_varchar2_table(304) := '096966286B3D3D276D27290A09090909097069636B65725F756C5F7475726E282779272C276C65667427293B0A0909090976203D206B65795F76616C7565732E6D61783B0A0909097D0A0909097069636B6572735B7069636B65722E69645D2E6B65795B';
wwv_flow_api.g_varchar2_table(305) := '6B5D2E63757272656E74203D20763B0A0909097069636B65725F756C5F7472616E736974696F6E286B2C76293B0A0A09097D2C0A09097069636B65725F756C5F7475726E203D2066756E6374696F6E286B2C6429207B0A0909097661720A090909097620';
wwv_flow_api.g_varchar2_table(306) := '3D206765745F63757272656E74286B293B0A090909696628643D3D27726967687427290A09090909762B2B3B0A090909656C73650A09090909762D2D3B0A0909097069636B65725F76616C7565735F696E637265617365286B2C76293B0A09097D2C0A09';
wwv_flow_api.g_varchar2_table(307) := '097069636B65725F616C7274203D2066756E6374696F6E2829207B0A0909097069636B65722E656C656D656E740A0909092E616464436C61737328277069636B65722D726D626C27293B0A09097D2C0A0A09092F2A20494E5055542046554E4354494F4E';
wwv_flow_api.g_varchar2_table(308) := '53202A2F0A0A0909696E7075745F66696C6C203D2066756E6374696F6E286E29207B0A09090972657475726E206E203C203130203F20273027202B206E203A206E0A09097D2C0A0909696E7075745F6F7264696E616C5F737566666978203D2066756E63';
wwv_flow_api.g_varchar2_table(309) := '74696F6E286E29207B0A0909097661720A09090909733D5B227468222C227374222C226E64222C227264225D2C0A09090909763D6E253130303B0A09090972657475726E206E2B28735B28762D3230292531305D7C7C735B765D7C7C735B305D293B0A09';
wwv_flow_api.g_varchar2_table(310) := '097D2C0A0909696E7075745F6368616E67655F76616C7565203D2066756E6374696F6E2829207B0A0A0909096966282169735F6C6F636B6564282926267069636B65725F6374726C29207B0A0A090909097661720A090909090964203D206765745F6375';
wwv_flow_api.g_varchar2_table(311) := '7272656E7428276427292C0A09090909096D203D206765745F63757272656E7428276D27292C0A090909090979203D206765745F63757272656E7428277927292C0A09090909096765745F646179203D206E65772044617465286D2B222F222B642B222F';
wwv_flow_api.g_varchar2_table(312) := '222B79292E67657444617928292C0A0A0909090909737472203D0A09090909097069636B6572735B7069636B65722E69645D2E666F726D61740A09090909092E7265706C616365282F5C622864295C622F672C20696E7075745F66696C6C286429290A09';
wwv_flow_api.g_varchar2_table(313) := '090909092E7265706C616365282F5C62286D295C622F672C20696E7075745F66696C6C286D29290A09090909092E7265706C616365282F5C622853295C622F672C20696E7075745F6F7264696E616C5F73756666697828642929202F2F6E65770A090909';
wwv_flow_api.g_varchar2_table(314) := '09092E7265706C616365282F5C622859295C622F672C2079290A09090909092E7265706C616365282F5C622855295C622F672C206765745F756E6978286765745F63757272656E745F66756C6C28292929202F2F6E65770A09090909092E7265706C6163';
wwv_flow_api.g_varchar2_table(315) := '65282F5C622844295C622F672C206931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E7765656B646179732E73686F72745B6765745F6461795D290A09090909092E7265706C616365282F5C62286C295C622F672C206931386E5B';
wwv_flow_api.g_varchar2_table(316) := '7069636B6572735B7069636B65722E69645D2E6C616E675D2E7765656B646179732E66756C6C5B6765745F6461795D290A09090909092E7265706C616365282F5C622846295C622F672C206931386E5B7069636B6572735B7069636B65722E69645D2E6C';
wwv_flow_api.g_varchar2_table(317) := '616E675D2E6D6F6E7468732E66756C6C5B6D2D315D290A09090909092E7265706C616365282F5C62284D295C622F672C206931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E6D6F6E7468732E73686F72745B6D2D315D290A0909';
wwv_flow_api.g_varchar2_table(318) := '0909092E7265706C616365282F5C62286E295C622F672C206D290A09090909092E7265706C616365282F5C62286A295C622F672C2064293B0A0A090909097069636B65720A090909092E696E7075740A090909092E76616C28737472290A090909092E63';
wwv_flow_api.g_varchar2_table(319) := '68616E676528293B0A0A090909097069636B65725F6374726C203D2066616C73653B0A0A0909097D0A0A09097D3B0A0A092F2F20474554205549204556454E540A0A0969662869735F746F7563682829290A09097661720A09090975695F6576656E7420';
wwv_flow_api.g_varchar2_table(320) := '3D207B0A0909090969203A2027746F7563687374617274272C0A090909096D093A2027746F7563686D6F7665272C0A0909090965203A2027746F756368656E64270A0909097D0A09656C73650A09097661720A09090975695F6576656E74203D207B0A09';
wwv_flow_api.g_varchar2_table(321) := '09090969203A20276D6F757365646F776E272C0A090909096D093A20276D6F7573656D6F7665272C0A0909090965203A20276D6F7573657570270A0909097D0A0A0A097661720A09097069636B65725F6E6F64655F656C203D20276469762E6461746564';
wwv_flow_api.g_varchar2_table(322) := '726F707065722E7069636B65722D666F637573273B0A0A092428646F63756D656E74290A0A0A092F2F434C4F5345205049434B45520A092E6F6E2827636C69636B272C66756E6374696F6E286529207B0A09096966287069636B657229207B0A09090969';
wwv_flow_api.g_varchar2_table(323) := '6628217069636B65722E696E7075742E697328652E7461726765742920262620217069636B65722E656C656D656E742E697328652E74617267657429202626207069636B65722E656C656D656E742E68617328652E746172676574292E6C656E67746820';
wwv_flow_api.g_varchar2_table(324) := '3D3D3D203029207B0A090909097069636B65725F6869646528293B0A090909097069636B5F64726167676564203D206E756C6C3B0A0909097D0A09097D0A097D290A0A092F2F4C4F434B20414E494D4154494F4E0A092E6F6E28637373652E612C706963';
wwv_flow_api.g_varchar2_table(325) := '6B65725F6E6F64655F656C202B20272E7069636B65722D726D626C272C66756E6374696F6E28297B0A09096966287069636B65722E656C656D656E742E686173436C61737328277069636B65722D726D626C2729290A090909242874686973292E72656D';
wwv_flow_api.g_varchar2_table(326) := '6F7665436C61737328277069636B65722D726D626C27293B0A097D290A0A092F2F48494445204D4F44414C204F5645524C41590A092E6F6E28637373652E742C272E7069636B65722D6D6F64616C2D6F7665726C6179272C66756E6374696F6E28297B0A';
wwv_flow_api.g_varchar2_table(327) := '0909242874686973292E72656D6F766528293B0A097D290A0A0A092F2F4C415247452D4D4F44452044415920434C49434B0A092E6F6E2875695F6576656E742E692C7069636B65725F6E6F64655F656C2B27202E7069636B2D6C67206C692E7069636B2D';
wwv_flow_api.g_varchar2_table(328) := '76272C66756E6374696F6E28297B0A09096765745F7069636B65725F656C7328272E7069636B2D6C672D62206C6927292E72656D6F7665436C61737328277069636B2D736C27293B0A0909242874686973292E616464436C61737328277069636B2D736C';
wwv_flow_api.g_varchar2_table(329) := '27293B0A09097069636B6572735B7069636B65722E69645D2E6B65795B2764275D2E63757272656E74203D20242874686973292E617474722827646174612D76616C756527293B0A09097069636B65725F756C5F7472616E736974696F6E282764272C24';
wwv_flow_api.g_varchar2_table(330) := '2874686973292E617474722827646174612D76616C75652729293B0A09097069636B65725F6374726C203D20747275653B0A097D290A0A092F2F425554544F4E204C415247452D4D4F44450A092E6F6E2827636C69636B272C7069636B65725F6E6F6465';
wwv_flow_api.g_varchar2_table(331) := '5F656C2B27202E7069636B2D62746E2D737A272C66756E6374696F6E28297B0A09097069636B65725F6C617267655F6F6E6F666628293B0A097D290A0A092F2F425554544F4E205452414E534C4154452D4D4F44450A092E6F6E2827636C69636B272C70';
wwv_flow_api.g_varchar2_table(332) := '69636B65725F6E6F64655F656C2B27202E7069636B2D62746E2D6C6E67272C66756E6374696F6E28297B0A09097069636B65725F7472616E736C6174655F6F6E6F666628293B0A097D290A0A092F2F4A554D500A092E6F6E2875695F6576656E742E692C';
wwv_flow_api.g_varchar2_table(333) := '7069636B65725F6E6F64655F656C2B27202E7069636B2D6172772E7069636B2D6172772D7332272C66756E6374696F6E2865297B0A0A0909652E70726576656E7444656661756C7428293B0A09097069636B5F64726167676564203D206E756C6C3B0A0A';
wwv_flow_api.g_varchar2_table(334) := '09097661720A090909692C0A0909096B203D20242874686973292E636C6F736573742827756C27292E6461746128276B27292C0A0909096A756D70203D207069636B6572735B7069636B65722E69645D2E6A756D703B0A0A090969662824287468697329';
wwv_flow_api.g_varchar2_table(335) := '2E686173436C61737328277069636B2D6172772D722729290A09090969203D206765745F63757272656E742827792729202B206A756D703B0A0909656C73650A09090969203D206765745F63757272656E742827792729202D206A756D703B0A0A090976';
wwv_flow_api.g_varchar2_table(336) := '61720A0909096A756D7065645F6172726179203D206765745F6A756D706564282779272C6A756D70293B0A0A0909696628693E6A756D7065645F61727261795B6A756D7065645F61727261792E6C656E6774682D315D290A09090969203D206A756D7065';
wwv_flow_api.g_varchar2_table(337) := '645F61727261795B305D3B0A0909696628693C6A756D7065645F61727261795B305D290A09090969203D206A756D7065645F61727261795B6A756D7065645F61727261792E6C656E6774682D315D3B0A0A09097069636B6572735B7069636B65722E6964';
wwv_flow_api.g_varchar2_table(338) := '5D2E6B65795B2779275D2E63757272656E74203D20693B0A09097069636B65725F756C5F7472616E736974696F6E282779272C6765745F63757272656E742827792729293B0A0A09097069636B65725F6374726C203D20747275653B0A0A097D290A0A09';
wwv_flow_api.g_varchar2_table(339) := '2F2F44454641554C54204152524F570A092E6F6E2875695F6576656E742E692C7069636B65725F6E6F64655F656C2B27202E7069636B2D6172772E7069636B2D6172772D7331272C66756E6374696F6E2865297B0A0909652E70726576656E7444656661';
wwv_flow_api.g_varchar2_table(340) := '756C7428293B0A09097069636B5F64726167676564203D206E756C6C3B0A09097661720A0909096B203D20242874686973292E636C6F736573742827756C27292E6461746128276B27293B0A0909696628242874686973292E686173436C617373282770';
wwv_flow_api.g_varchar2_table(341) := '69636B2D6172772D722729290A0909097069636B65725F756C5F7475726E286B2C27726967687427293B0A0909656C73650A0909097069636B65725F756C5F7475726E286B2C276C65667427293B0A0A09097069636B65725F6374726C203D2074727565';
wwv_flow_api.g_varchar2_table(342) := '3B0A0A097D290A0A092F2F204A554D500A092E6F6E2875695F6576656E742E692C7069636B65725F6E6F64655F656C2B2720756C2E7069636B2E7069636B2D79206C69272C66756E6374696F6E28297B0A090969735F636C69636B203D20747275653B0A';
wwv_flow_api.g_varchar2_table(343) := '097D290A092E6F6E2875695F6576656E742E652C7069636B65725F6E6F64655F656C2B2720756C2E7069636B2E7069636B2D79206C69272C66756E6374696F6E28297B0A090969662869735F636C69636B262669735F6A756D7061626C65282929207B0A';
wwv_flow_api.g_varchar2_table(344) := '090909242874686973292E636C6F736573742827756C27292E746F67676C65436C61737328277069636B2D6A756D7027293B0A0909097661720A090909096A756D706564203D206765745F636C6F736573745F6A756D706564286765745F63757272656E';
wwv_flow_api.g_varchar2_table(345) := '7428277927292C6765745F6A756D706564282779272C7069636B6572735B7069636B65722E69645D2E6A756D7029293B0A0909097069636B6572735B7069636B65722E69645D2E6B65795B2779275D2E63757272656E74203D206A756D7065643B0A0909';
wwv_flow_api.g_varchar2_table(346) := '097069636B65725F756C5F7472616E736974696F6E282779272C6765745F63757272656E742827792729293B0A09090969735F636C69636B203D2066616C73653B0A09097D0A097D290A0A092F2F544F47474C452043414C454E4441520A092E6F6E2875';
wwv_flow_api.g_varchar2_table(347) := '695F6576656E742E692C7069636B65725F6E6F64655F656C2B2720756C2E7069636B2E7069636B2D64206C69272C66756E6374696F6E28297B0A090969735F636C69636B203D20747275653B0A097D290A092E6F6E2875695F6576656E742E652C706963';
wwv_flow_api.g_varchar2_table(348) := '6B65725F6E6F64655F656C2B2720756C2E7069636B2E7069636B2D64206C69272C66756E6374696F6E28297B0A090969662869735F636C69636B29207B0A0909097069636B65725F6C617267655F6F6E6F666628293B0A09090969735F636C69636B203D';
wwv_flow_api.g_varchar2_table(349) := '2066616C73653B0A09097D0A097D290A0A092F2F544F47474C45205452414E534C415445204D4F44450A092E6F6E2875695F6576656E742E692C7069636B65725F6E6F64655F656C2B2720756C2E7069636B2E7069636B2D6C206C69272C66756E637469';
wwv_flow_api.g_varchar2_table(350) := '6F6E28297B0A090969735F636C69636B203D20747275653B0A097D290A092E6F6E2875695F6576656E742E652C7069636B65725F6E6F64655F656C2B2720756C2E7069636B2E7069636B2D6C206C69272C66756E6374696F6E28297B0A09096966286973';
wwv_flow_api.g_varchar2_table(351) := '5F636C69636B29207B0A0909097069636B65725F7472616E736C6174655F6F6E6F666628293B0A0909097069636B65725F7472616E736C61746528242874686973292E76616C2829293B0A09090969735F636C69636B203D2066616C73653B0A09097D0A';
wwv_flow_api.g_varchar2_table(352) := '097D290A0A092F2F4D4F555345444F574E204F4E20554C0A092E6F6E2875695F6576656E742E692C7069636B65725F6E6F64655F656C2B2720756C2E7069636B272C66756E6374696F6E2865297B0A09097069636B5F64726167676564203D2024287468';
wwv_flow_api.g_varchar2_table(353) := '6973293B0A09096966287069636B5F6472616767656429207B0A0909097661720A090909096B203D207069636B5F647261676765642E6461746128276B27293B0A0909097069636B5F647261675F6F6666736574203D2069735F746F7563682829203F20';
wwv_flow_api.g_varchar2_table(354) := '652E6F726967696E616C4576656E742E746F75636865735B305D2E7061676559203A20652E70616765593B0A0909097069636B5F647261675F74656D70203D206765745F63757272656E74286B293B0A09097D0A097D290A0A092F2F4D4F5553454D4F56';
wwv_flow_api.g_varchar2_table(355) := '45204F4E20554C0A092E6F6E2875695F6576656E742E6D2C66756E6374696F6E2865297B0A0A090969735F636C69636B203D2066616C73653B0A0A09096966287069636B5F6472616767656429207B0A090909652E70726576656E7444656661756C7428';
wwv_flow_api.g_varchar2_table(356) := '293B0A0909097661720A090909096B203D207069636B5F647261676765642E6461746128276B27293B0A090909096F203D2069735F746F7563682829203F20652E6F726967696E616C4576656E742E746F75636865735B305D2E7061676559203A20652E';
wwv_flow_api.g_varchar2_table(357) := '70616765593B0A0909096F203D207069636B5F647261675F6F6666736574202D206F3B0A0909096F203D204D6174682E726F756E64286F202A202E303236293B0A09090969203D207069636B5F647261675F74656D70202B206F3B0A0909097661720A09';
wwv_flow_api.g_varchar2_table(358) := '090909696E74203D206765745F636C656172286B2C69293B0A090909696628696E74213D7069636B6572735B7069636B65722E69645D2E6B65795B6B5D2E63757272656E74290A090909097069636B65725F76616C7565735F696E637265617365286B2C';
wwv_flow_api.g_varchar2_table(359) := '696E74293B0A0A0909097069636B65725F6374726C203D20747275653B0A09097D0A097D290A0A092F2F4D4F5553455550204F4E20554C0A092E6F6E2875695F6576656E742E652C66756E6374696F6E2865297B0A0909696628207069636B5F64726167';
wwv_flow_api.g_varchar2_table(360) := '67656420290A0909097069636B5F64726167676564203D206E756C6C2C0A0909097069636B5F647261675F6F6666736574203D206E756C6C2C0A0909097069636B5F647261675F74656D70203D206E756C6C3B0A09096966287069636B6572290A090909';
wwv_flow_api.g_varchar2_table(361) := '7069636B65725F73657428293B0A097D290A0A092F2F434C49434B205355424D49540A092E6F6E2875695F6576656E742E692C7069636B65725F6E6F64655F656C2B27202E7069636B2D7375626D6974272C66756E6374696F6E28297B0A09097069636B';
wwv_flow_api.g_varchar2_table(362) := '65725F6869646528293B0A097D293B0A0A09242877696E646F77292E726573697A652866756E6374696F6E28297B0A09096966287069636B657229207B0A0909097069636B65725F6F666673657428293B0A09090969735F66785F6D6F62696C6528293B';
wwv_flow_api.g_varchar2_table(363) := '0A09097D0A097D293B0A0A09242E666E2E6461746544726F70706572203D2066756E6374696F6E286F7074696F6E7329207B0A090972657475726E20242874686973292E656163682866756E6374696F6E28297B0A090909696628242874686973292E69';
wwv_flow_api.g_varchar2_table(364) := '732827696E7075742729262621242874686973292E686173436C61737328277069636B65722D696E707574272929207B0A0A090909097661720A0909090909696E707574203D20242874686973292C0A09090909096964203D20276461746564726F7070';
wwv_flow_api.g_varchar2_table(365) := '65722D27202B204F626A6563742E6B657973287069636B657273292E6C656E6774683B0A0A09090909696E7075740A090909092E617474722827646174612D6964272C6964290A090909092E616464436C61737328277069636B65722D696E7075742729';
wwv_flow_api.g_varchar2_table(366) := '0A090909092E70726F70287B0A09090909092774797065273A2774657874272C0A090909090927726561646F6E6C7927203A20747275650A090909097D293B0A0A090909097661720A09090909097069636B65725F64656661756C745F64617465203D20';
wwv_flow_api.g_varchar2_table(367) := '28696E7075742E64617461282764656661756C742D646174652729262669735F6461746528696E7075742E64617461282764656661756C742D6461746527292929203F20696E7075742E64617461282764656661756C742D646174652729203A206E756C';
wwv_flow_api.g_varchar2_table(368) := '6C2C0A09090909097069636B65725F64697361626C65645F64617973203D2028696E7075742E64617461282764697361626C65642D64617973272929203F20696E7075742E64617461282764697361626C65642D6461797327292E73706C697428272C27';
wwv_flow_api.g_varchar2_table(369) := '29203A206E756C6C2C0A09090909097069636B65725F666F726D6174203D20696E7075742E646174612827666F726D61742729207C7C20276D2F642F59272C0A09090909097069636B65725F6678203D2028696E7075742E646174612827667827293D3D';
wwv_flow_api.g_varchar2_table(370) := '3D66616C736529203F20696E7075742E64617461282766782729203A20747275652C0A09090909097069636B65725F66785F636C617373203D2028696E7075742E646174612827667827293D3D3D66616C736529203F202727203A20277069636B65722D';
wwv_flow_api.g_varchar2_table(371) := '667873272C0A09090909097069636B65725F66785F6D6F62696C65203D2028696E7075742E64617461282766782D6D6F62696C6527293D3D3D66616C736529203F20696E7075742E64617461282766782D6D6F62696C652729203A20747275652C0A0909';
wwv_flow_api.g_varchar2_table(372) := '0909097069636B65725F696E69745F736574203D2028696E7075742E646174612827696E69742D73657427293D3D3D66616C736529203F2066616C7365203A20747275652C0A09090909097069636B65725F6C616E67203D2028696E7075742E64617461';
wwv_flow_api.g_varchar2_table(373) := '28276C616E672729262628696E7075742E6461746128276C616E67272920696E206931386E2929203F20696E7075742E6461746128276C616E672729203A2027656E272C0A09090909097069636B65725F6C61726765203D2028696E7075742E64617461';
wwv_flow_api.g_varchar2_table(374) := '28276C617267652D6D6F646527293D3D3D7472756529203F2074727565203A2066616C73652C0A09090909097069636B65725F6C617267655F636C617373203D2028696E7075742E6461746128276C617267652D64656661756C7427293D3D3D74727565';
wwv_flow_api.g_varchar2_table(375) := '202626207069636B65725F6C617267653D3D3D7472756529203F20277069636B65722D6C6727203A2027272C0A09090909097069636B65725F6C6F636B203D2028696E7075742E6461746128276C6F636B27293D3D2766726F6D277C7C696E7075742E64';
wwv_flow_api.g_varchar2_table(376) := '61746128276C6F636B27293D3D27746F2729203F20696E7075742E6461746128276C6F636B2729203A2066616C73652C0A09090909097069636B65725F6A756D70203D2028696E7075742E6461746128276A756D702729262669735F696E7428696E7075';
wwv_flow_api.g_varchar2_table(377) := '742E6461746128276A756D7027292929203F20696E7075742E6461746128276A756D702729203A2031302C0A09090909097069636B65725F6D61785F79656172203D2028696E7075742E6461746128276D61782D796561722729262669735F696E742869';
wwv_flow_api.g_varchar2_table(378) := '6E7075742E6461746128276D61782D7965617227292929203F20696E7075742E6461746128276D61782D796561722729203A206E6577204461746528292E67657446756C6C5965617228292C0A09090909097069636B65725F6D696E5F79656172203D20';
wwv_flow_api.g_varchar2_table(379) := '28696E7075742E6461746128276D696E2D796561722729262669735F696E7428696E7075742E6461746128276D696E2D7965617227292929203F20696E7075742E6461746128276D696E2D796561722729203A20313937302C0A0A09090909097069636B';
wwv_flow_api.g_varchar2_table(380) := '65725F6D6F64616C203D2028696E7075742E6461746128276D6F64616C27293D3D3D7472756529203F20277069636B65722D6D6F64616C27203A2027272C0A09090909097069636B65725F7468656D65203D20696E7075742E6461746128277468656D65';
wwv_flow_api.g_varchar2_table(381) := '2729207C7C20277072696D617279272C0A09090909097069636B65725F7472616E736C6174655F6D6F6465203D2028696E7075742E6461746128277472616E736C6174652D6D6F646527293D3D3D7472756529203F2074727565203A2066616C73653B0A';
wwv_flow_api.g_varchar2_table(382) := '0A090909096966287069636B65725F64697361626C65645F6461797329207B0A0909090909242E65616368287069636B65725F64697361626C65645F646179732C2066756E6374696F6E2820696E6465782C2076616C75652029207B0A09090909090969';
wwv_flow_api.g_varchar2_table(383) := '662876616C7565262669735F646174652876616C756529290A090909090909097069636B65725F64697361626C65645F646179735B696E6465785D203D206765745F756E69782876616C7565293B0A09090909097D293B0A090909097D0A0A0909090970';
wwv_flow_api.g_varchar2_table(384) := '69636B6572735B69645D203D207B0A090909090964697361626C6564617973203A207069636B65725F64697361626C65645F646179732C0A0909090909666F726D6174203A207069636B65725F666F726D61742C0A09090909096678203A207069636B65';
wwv_flow_api.g_varchar2_table(385) := '725F66782C0A090909090966786D6F62696C65203A207069636B65725F66785F6D6F62696C652C0A09090909096C616E67203A207069636B65725F6C616E672C0A09090909096C61726765203A207069636B65725F6C617267652C0A09090909096C6F63';
wwv_flow_api.g_varchar2_table(386) := '6B203A207069636B65725F6C6F636B2C0A09090909096A756D70203A207069636B65725F6A756D702C0A09090909096B6579203A207B0A0909090909096D203A207B0A090909090909096D696E203A20312C0A090909090909096D6178203A2031322C0A';
wwv_flow_api.g_varchar2_table(387) := '0909090909090963757272656E74203A20312C0A09090909090909746F646179203A20286E6577204461746528292E6765744D6F6E746828292B31290A0909090909097D2C0A09090909090964203A207B0A090909090909096D696E203A20312C0A0909';
wwv_flow_api.g_varchar2_table(388) := '09090909096D6178203A2033312C0A0909090909090963757272656E74203A20312C0A09090909090909746F646179203A206E6577204461746528292E6765744461746528290A0909090909097D2C0A09090909090979203A207B0A090909090909096D';
wwv_flow_api.g_varchar2_table(389) := '696E203A207069636B65725F6D696E5F796561722C0A090909090909096D6178203A207069636B65725F6D61785F796561722C0A0909090909090963757272656E74203A207069636B65725F6D696E5F796561722C0A09090909090909746F646179203A';
wwv_flow_api.g_varchar2_table(390) := '206E6577204461746528292E67657446756C6C5965617228290A0909090909097D2C0A0909090909096C203A207B0A090909090909096D696E203A20302C0A090909090909096D6178203A204F626A6563742E6B657973286931386E292E6C656E677468';
wwv_flow_api.g_varchar2_table(391) := '2D312C0A0909090909090963757272656E74203A20302C0A09090909090909746F646179203A20300A0909090909097D0A09090909097D2C0A09090909097472616E736C617465203A207069636B65725F7472616E736C6174655F6D6F64650A09090909';
wwv_flow_api.g_varchar2_table(392) := '7D3B0A0A090909096966287069636B65725F64656661756C745F6461746529207B0A0A0909090909766172207265676578203D202F5C642B2F673B0A090909090976617220737472696E67203D207069636B65725F64656661756C745F646174653B0A09';
wwv_flow_api.g_varchar2_table(393) := '09090909766172206D617463686573203D20737472696E672E6D61746368287265676578293B0A0A0909090909242E65616368286D6174636865732C2066756E6374696F6E2820696E6465782C2076616C75652029207B0A0909090909096D6174636865';
wwv_flow_api.g_varchar2_table(394) := '735B696E6465785D203D207061727365496E742876616C7565293B0A09090909097D293B0A0A09090909097069636B6572735B69645D2E6B65792E6D2E746F646179203D20286D6174636865735B305D26266D6174636865735B305D3C3D313229203F20';
wwv_flow_api.g_varchar2_table(395) := '6D6174636865735B305D203A207069636B6572735B69645D2E6B65792E6D2E746F6461793B0A09090909097069636B6572735B69645D2E6B65792E642E746F646179203D20286D6174636865735B315D26266D6174636865735B315D3C3D333129203F20';
wwv_flow_api.g_varchar2_table(396) := '6D6174636865735B315D203A207069636B6572735B69645D2E6B65792E642E746F6461793B0A09090909097069636B6572735B69645D2E6B65792E792E746F646179203D20286D6174636865735B325D29203F206D6174636865735B325D203A20706963';
wwv_flow_api.g_varchar2_table(397) := '6B6572735B69645D2E6B65792E792E746F6461793B0A0A09090909096966287069636B6572735B69645D2E6B65792E792E746F6461793E7069636B6572735B69645D2E6B65792E792E6D6178290A0909090909097069636B6572735B69645D2E6B65792E';
wwv_flow_api.g_varchar2_table(398) := '792E6D6178203D207069636B6572735B69645D2E6B65792E792E746F6461793B0A09090909096966287069636B6572735B69645D2E6B65792E792E746F6461793C7069636B6572735B69645D2E6B65792E792E6D696E290A0909090909097069636B6572';
wwv_flow_api.g_varchar2_table(399) := '735B69645D2E6B65792E792E6D696E203D207069636B6572735B69645D2E6B65792E792E746F6461793B0A0A090909097D0A0A090909092428273C6469763E272C207B0A0909090909636C6173733A20276461746564726F707065722027202B20706963';
wwv_flow_api.g_varchar2_table(400) := '6B65725F6D6F64616C202B20272027202B207069636B65725F7468656D65202B20272027202B207069636B65725F66785F636C617373202B20272027202B207069636B65725F6C617267655F636C6173732C0A090909090969643A2069642C0A09090909';
wwv_flow_api.g_varchar2_table(401) := '0968746D6C3A202428273C6469763E272C207B0A090909090909636C6173733A20277069636B6572270A09090909097D290A090909097D290A090909092E617070656E64546F2827626F647927293B0A0A090909097069636B6572203D207B0A09090909';
wwv_flow_api.g_varchar2_table(402) := '096964203A2069642C0A0909090909696E707574203A20696E7075742C0A0909090909656C656D656E74203A202428272327202B206964290A090909097D3B0A0A09090909666F722820766172206B20696E207069636B6572735B69645D2E6B65792029';
wwv_flow_api.g_varchar2_table(403) := '207B0A09090909092428273C756C3E272C207B0A090909090909636C6173733A20277069636B207069636B2D27202B206B2C0A09090909090927646174612D6B27203A206B0A09090909097D290A09090909092E617070656E64546F286765745F706963';
wwv_flow_api.g_varchar2_table(404) := '6B65725F656C7328272E7069636B65722729293B0A09090909097069636B65725F72656E6465725F756C286B293B0A090909097D0A0A090909096966287069636B6572735B69645D2E6C6172676529207B0A0A09090909092F2F63616C656E6461720A09';
wwv_flow_api.g_varchar2_table(405) := '090909092428273C6469763E272C207B0A090909090909636C6173733A20277069636B2D6C67270A09090909097D290A09090909092E696E736572744265666F7265286765745F7069636B65725F656C7328272E7069636B2D642729293B0A0A09090909';
wwv_flow_api.g_varchar2_table(406) := '092428273C756C20636C6173733D227069636B2D6C672D68223E3C2F756C3E3C756C20636C6173733D227069636B2D6C672D62223E3C2F756C3E27290A09090909092E617070656E64546F286765745F7069636B65725F656C7328272E7069636B2D6C67';
wwv_flow_api.g_varchar2_table(407) := '2729293B0A0A09090909097661720A0909090909097069636B65725F6461795F6F6666736574203D206765745F646179735F617272617928293B0A0A0909090909666F72287661722069203D20303B2069203C2037203B20692B2B29207B0A0909090909';
wwv_flow_api.g_varchar2_table(408) := '092428273C6C693E272C207B0A0909090909090968746D6C3A206931386E5B7069636B6572735B7069636B65722E69645D2E6C616E675D2E7765656B646179732E73686F72745B7069636B65725F6461795F6F66667365745B695D5D0A0909090909097D';
wwv_flow_api.g_varchar2_table(409) := '290A0909090909092E617070656E64546F286765745F7069636B65725F656C7328272E7069636B2D6C67202E7069636B2D6C672D682729290A09090909097D0A0909090909666F72287661722069203D20303B2069203C203432203B20692B2B29207B0A';
wwv_flow_api.g_varchar2_table(410) := '0909090909092428273C6C693E27290A0909090909092E617070656E64546F286765745F7069636B65725F656C7328272E7069636B2D6C67202E7069636B2D6C672D622729290A09090909097D0A090909097D0A0A090909092F2F627574746F6E730A09';
wwv_flow_api.g_varchar2_table(411) := '0909092428273C6469763E272C207B0A0909090909636C6173733A20277069636B2D62746E73270A090909097D290A090909092E617070656E64546F286765745F7069636B65725F656C7328272E7069636B65722729293B0A0A090909092428273C6469';
wwv_flow_api.g_varchar2_table(412) := '763E272C207B0A0909090909636C6173733A20277069636B2D7375626D6974270A090909097D290A090909092E617070656E64546F286765745F7069636B65725F656C7328272E7069636B2D62746E732729293B0A0A090909096966287069636B657273';
wwv_flow_api.g_varchar2_table(413) := '5B7069636B65722E69645D2E7472616E736C61746529207B0A09090909092428273C6469763E272C207B0A090909090909636C6173733A20277069636B2D62746E207069636B2D62746E2D6C6E67270A09090909097D290A09090909092E617070656E64';
wwv_flow_api.g_varchar2_table(414) := '546F286765745F7069636B65725F656C7328272E7069636B2D62746E732729293B0A090909097D0A090909096966287069636B6572735B7069636B65722E69645D2E6C6172676529207B0A09090909092428273C6469763E272C207B0A09090909090963';
wwv_flow_api.g_varchar2_table(415) := '6C6173733A20277069636B2D62746E207069636B2D62746E2D737A270A09090909097D290A09090909092E617070656E64546F286765745F7069636B65725F656C7328272E7069636B2D62746E732729293B0A090909097D0A0A09090909696628706963';
wwv_flow_api.g_varchar2_table(416) := '6B65725F666F726D61743D3D2759277C7C7069636B65725F666F726D61743D3D276D2729207B0A09090909096765745F7069636B65725F656C7328272E7069636B2D642C2E7069636B2D62746E2D737A27292E6869646528293B0A09090909097069636B';
wwv_flow_api.g_varchar2_table(417) := '65722E656C656D656E742E616464436C61737328277069636B65722D74696E7927293B0A09090909096966287069636B65725F666F726D61743D3D275927290A0909090909096765745F7069636B65725F656C7328272E7069636B2D6D2C2E7069636B2D';
wwv_flow_api.g_varchar2_table(418) := '62746E2D6C6E6727292E6869646528293B0A09090909096966287069636B65725F666F726D61743D3D276D27290A0909090909096765745F7069636B65725F656C7328272E7069636B2D7927292E6869646528293B0A090909097D0A0A09090909696628';
wwv_flow_api.g_varchar2_table(419) := '7069636B65725F696E69745F73657429207B0A09090909097069636B65725F6374726C203D20747275653B0A0909090909696E7075745F6368616E67655F76616C756528293B0A090909097D0A0A090909097069636B6572203D206E756C6C3B0A0A0909';
wwv_flow_api.g_varchar2_table(420) := '097D0A0A09097D290A09092E666F6375732866756E6374696F6E2865297B0A0A090909652E70726576656E7444656661756C7428293B0A090909242874686973292E626C757228293B0A0A0909096966287069636B6572290A090909097069636B65725F';
wwv_flow_api.g_varchar2_table(421) := '6869646528293B0A0A0909097069636B6572203D207B0A090909096964203A20242874686973292E646174612827696427292C0A09090909696E707574203A20242874686973292C0A09090909656C656D656E74203A2024282723272B24287468697329';
wwv_flow_api.g_varchar2_table(422) := '2E64617461282769642729290A0909097D3B0A0A09090969735F66785F6D6F62696C6528293B0A0909097069636B65725F6F666673657428293B0A0909097069636B65725F73657428293B0A0909097069636B65725F73686F7728293B0A0A0909096966';
wwv_flow_api.g_varchar2_table(423) := '287069636B65722E656C656D656E742E686173436C61737328277069636B65722D6D6F64616C2729290A09090909242827626F647927292E617070656E6428273C64697620636C6173733D227069636B65722D6D6F64616C2D6F7665726C6179223E3C2F';
wwv_flow_api.g_varchar2_table(424) := '6469763E27290A0A09097D293B0A097D3B0A7D286A517565727929293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395084233353574694)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/lib/Datedropper3/datedropper.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '40666F6E742D666163657B666F6E742D66616D696C793A6461746564726F707065723B7372633A75726C287372632F6461746564726F707065722E656F74293B7372633A75726C287372632F6461746564726F707065722E656F743F2369656669782920';
wwv_flow_api.g_varchar2_table(2) := '666F726D61742822656D6265646465642D6F70656E7479706522292C75726C287372632F6461746564726F707065722E776F66662920666F726D61742822776F666622292C75726C287372632F6461746564726F707065722E7474662920666F726D6174';
wwv_flow_api.g_varchar2_table(3) := '2822747275657479706522292C75726C287372632F6461746564726F707065722E737667236461746564726F707065722920666F726D6174282273766722293B666F6E742D7765696768743A3430303B666F6E742D7374796C653A6E6F726D616C7D5B63';
wwv_flow_api.g_varchar2_table(4) := '6C6173732A3D22207069636B2D692D225D3A6265666F72652C5B636C6173735E3D7069636B2D692D5D3A6265666F72657B666F6E742D66616D696C793A6461746564726F7070657221696D706F7274616E743B666F6E742D7374796C653A6E6F726D616C';
wwv_flow_api.g_varchar2_table(5) := '21696D706F7274616E743B666F6E742D7765696768743A34303021696D706F7274616E743B666F6E742D76617269616E743A6E6F726D616C21696D706F7274616E743B746578742D7472616E73666F726D3A6E6F6E6521696D706F7274616E743B737065';
wwv_flow_api.g_varchar2_table(6) := '616B3A6E6F6E653B6C696E652D6865696768743A313B2D7765626B69742D666F6E742D736D6F6F7468696E673A616E7469616C69617365643B2D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A677261797363616C657D2E7069636B2D692D6C';
wwv_flow_api.g_varchar2_table(7) := '6E673A6265666F72657B636F6E74656E743A225C3661227D2E7069636B2D692D6C6B643A6265666F72657B636F6E74656E743A225C3632227D2E7069636B2D692D636B643A6265666F72657B636F6E74656E743A225C3635227D2E7069636B2D692D723A';
wwv_flow_api.g_varchar2_table(8) := '6265666F72657B636F6E74656E743A225C3636227D2E7069636B2D692D6C3A6265666F72657B636F6E74656E743A225C3638227D2E7069636B2D692D6D696E3A6265666F72657B636F6E74656E743A225C3631227D2E7069636B2D692D6578703A626566';
wwv_flow_api.g_varchar2_table(9) := '6F72657B636F6E74656E743A225C3633227D2E7069636B65722D696E7075747B637572736F723A746578747D2E7069636B65722D6D6F64616C2D6F7665726C61797B706F736974696F6E3A66697865643B746F703A303B6C6566743A303B77696474683A';
wwv_flow_api.g_varchar2_table(10) := '313030253B6865696768743A313030253B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E38293B7A2D696E6465783A393939383B6F7061636974793A313B7669736962696C6974793A76697369626C653B2D7765626B69742D74';
wwv_flow_api.g_varchar2_table(11) := '72616E736974696F6E3A6F706163697479202E347320656173652C7669736962696C697479202E347320656173653B2D6D6F7A2D7472616E736974696F6E3A6F706163697479202E347320656173652C7669736962696C697479202E347320656173653B';
wwv_flow_api.g_varchar2_table(12) := '2D6D732D7472616E736974696F6E3A6F706163697479202E347320656173652C7669736962696C697479202E347320656173653B2D6F2D7472616E736974696F6E3A6F706163697479202E347320656173652C7669736962696C697479202E3473206561';
wwv_flow_api.g_varchar2_table(13) := '73657D2E7069636B65722D6D6F64616C2D6F7665726C61792E746F686964657B6F7061636974793A303B7669736962696C6974793A68696464656E7D6469762E6461746564726F707065727B706F736974696F6E3A6162736F6C7574653B746F703A303B';
wwv_flow_api.g_varchar2_table(14) := '6C6566743A303B7A2D696E6465783A393939393B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D353025293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D353025293B2D6D732D7472616E73666F726D';
wwv_flow_api.g_varchar2_table(15) := '3A7472616E736C61746558282D353025293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D353025293B6C696E652D6865696768743A313B666F6E742D66616D696C793A73616E732D73657269663B2D7765626B69742D626F782D73697A';
wwv_flow_api.g_varchar2_table(16) := '696E673A626F726465722D626F783B2D6D6F7A2D626F782D73697A696E673A626F726465722D626F783B626F782D73697A696E673A626F726465722D626F783B2D7765626B69742D757365722D73656C6563743A6E6F6E653B2D6D6F7A2D757365722D73';
wwv_flow_api.g_varchar2_table(17) := '656C6563743A6E6F6E653B2D6D732D757365722D73656C6563743A6E6F6E653B2D6F2D757365722D73656C6563743A6E6F6E653B757365722D73656C6563743A6E6F6E653B2D7765626B69742D7461702D686967686C696768742D636F6C6F723A726762';
wwv_flow_api.g_varchar2_table(18) := '6128302C302C302C30293B6F7061636974793A303B7669736962696C6974793A68696464656E3B6D617267696E2D746F703A2D3870783B7472616E73666F726D2D7374796C653A70726573657276652D33643B2D7765626B69742D706572737065637469';
wwv_flow_api.g_varchar2_table(19) := '76653A313030303B2D6D6F7A2D70657273706563746976653A313030303B2D6D732D70657273706563746976653A313030303B70657273706563746976653A313030303B2D7765626B69742D6261636B666163652D7669736962696C6974793A68696464';
wwv_flow_api.g_varchar2_table(20) := '656E3B2D6D6F7A2D6261636B666163652D7669736962696C6974793A68696464656E3B2D6D732D6261636B666163652D7669736962696C6974793A68696464656E3B6261636B666163652D7669736962696C6974793A68696464656E7D6469762E646174';
wwv_flow_api.g_varchar2_table(21) := '6564726F707065723A6265666F72657B636F6E74656E743A22223B706F736974696F6E3A6162736F6C7574653B77696474683A313670783B6865696768743A313670783B746F703A2D3870783B6C6566743A3530253B2D7765626B69742D7472616E7366';
wwv_flow_api.g_varchar2_table(22) := '6F726D3A7472616E736C61746558282D3530252920726F74617465283435646567293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D3530252920726F74617465283435646567293B2D6D732D7472616E73666F726D3A7472616E73';
wwv_flow_api.g_varchar2_table(23) := '6C61746558282D3530252920726F74617465283435646567293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D3530252920726F74617465283435646567293B626F726465722D746F702D6C6566742D7261646975733A3470787D646976';
wwv_flow_api.g_varchar2_table(24) := '2E6461746564726F707065722E7069636B65722D666F6375737B6F7061636974793A313B7669736962696C6974793A76697369626C653B6D617267696E2D746F703A3870787D6469762E6461746564726F707065722E7069636B65722D6D6F64616C7B74';
wwv_flow_api.g_varchar2_table(25) := '6F703A35302521696D706F7274616E743B6C6566743A35302521696D706F7274616E743B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D3530252921696D706F7274616E743B2D6D6F7A2D7472616E73666F726D3A';
wwv_flow_api.g_varchar2_table(26) := '7472616E736C617465282D3530252C2D3530252921696D706F7274616E743B2D6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D3530252921696D706F7274616E743B2D6F2D7472616E73666F726D3A7472616E736C617465282D';
wwv_flow_api.g_varchar2_table(27) := '3530252C2D3530252921696D706F7274616E743B706F736974696F6E3A666978656421696D706F7274616E743B6D617267696E3A3021696D706F7274616E747D6469762E6461746564726F707065722E7069636B65722D6D6F64616C3A6265666F72657B';
wwv_flow_api.g_varchar2_table(28) := '646973706C61793A6E6F6E657D6469762E6461746564726F70706572202E7069636B65727B6F766572666C6F773A68696464656E7D6469762E6461746564726F70706572202E7069636B657220756C7B6D617267696E3A303B70616464696E673A303B6C';
wwv_flow_api.g_varchar2_table(29) := '6973742D7374796C653A6E6F6E653B637572736F723A706F696E7465727D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B7B706F736974696F6E3A72656C61746976653B6F766572666C6F773A68696464656E3B6D61782D';
wwv_flow_api.g_varchar2_table(30) := '6865696768743A31303070787D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B3A6E74682D6F662D747970652832297B626F782D736861646F773A3020317078207267626128302C302C302C2E3036297D6469762E646174';
wwv_flow_api.g_varchar2_table(31) := '6564726F70706572202E7069636B657220756C2E7069636B206C697B706F736974696F6E3A6162736F6C7574653B746F703A303B6C6566743A303B77696474683A313030253B6865696768743A313030253B746578742D616C69676E3A63656E7465723B';
wwv_flow_api.g_varchar2_table(32) := '6F7061636974793A2E353B646973706C61793A626C6F636B7D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B206C692E7069636B2D6166727B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559283130';
wwv_flow_api.g_varchar2_table(33) := '3025293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592831303025293B2D6D732D7472616E73666F726D3A7472616E736C617465592831303025293B2D6F2D7472616E73666F726D3A7472616E736C617465592831303025297D646976';
wwv_flow_api.g_varchar2_table(34) := '2E6461746564726F70706572202E7069636B657220756C2E7069636B206C692E7069636B2D6266727B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D31303025293B2D6D6F7A2D7472616E73666F726D3A7472616E736C6174';
wwv_flow_api.g_varchar2_table(35) := '6559282D31303025293B2D6D732D7472616E73666F726D3A7472616E736C61746559282D31303025293B2D6F2D7472616E73666F726D3A7472616E736C61746559282D31303025297D6469762E6461746564726F70706572202E7069636B657220756C2E';
wwv_flow_api.g_varchar2_table(36) := '7069636B206C692E7069636B2D736C7B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592830293B2D6D732D7472616E73666F726D';
wwv_flow_api.g_varchar2_table(37) := '3A7472616E736C617465592830293B2D6F2D7472616E73666F726D3A7472616E736C617465592830293B7A2D696E6465783A317D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B206C69207370616E7B666F6E742D73697A';
wwv_flow_api.g_varchar2_table(38) := '653A313670783B706F736974696F6E3A6162736F6C7574653B6C6566743A303B77696474683A313030253B6C696E652D6865696768743A303B626F74746F6D3A323470787D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B';
wwv_flow_api.g_varchar2_table(39) := '202E7069636B2D6172777B706F736974696F6E3A6162736F6C7574653B746F703A303B6865696768743A313030253B77696474683A3235253B666F6E742D73697A653A313070783B746578742D616C69676E3A63656E7465723B646973706C61793A626C';
wwv_flow_api.g_varchar2_table(40) := '6F636B3B7A2D696E6465783A31303B637572736F723A706F696E7465723B6261636B67726F756E642D73697A653A3234707820323470783B6261636B67726F756E642D706F736974696F6E3A63656E7465723B6261636B67726F756E642D726570656174';
wwv_flow_api.g_varchar2_table(41) := '3A6E6F2D7265706561743B6F766572666C6F773A68696464656E3B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7363616C652830293B2D6D6F7A2D7472616E73666F726D3A7363616C652830293B2D6D732D7472616E73666F72';
wwv_flow_api.g_varchar2_table(42) := '6D3A7363616C652830293B2D6F2D7472616E73666F726D3A7363616C652830297D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D61727720697B6C696E652D6865696768743A303B746F703A3530253B70';
wwv_flow_api.g_varchar2_table(43) := '6F736974696F6E3A72656C61746976653B646973706C61793A626C6F636B3B2D7765626B69742D7472616E73666F726D3A7472616E736C61746559282D353025293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746559282D353025293B2D6D';
wwv_flow_api.g_varchar2_table(44) := '732D7472616E73666F726D3A7472616E736C61746559282D353025293B2D6F2D7472616E73666F726D3A7472616E736C61746559282D353025297D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D617277';
wwv_flow_api.g_varchar2_table(45) := '2E7069636B2D6172772D73313A686F7665727B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7363616C6528312E32293B2D6D6F7A2D7472616E73666F726D3A7363616C6528312E32293B2D6D732D7472616E73666F726D3A7363';
wwv_flow_api.g_varchar2_table(46) := '616C6528312E32293B2D6F2D7472616E73666F726D3A7363616C6528312E32297D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D722C6469762E6461746564726F707065';
wwv_flow_api.g_varchar2_table(47) := '72202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D7220697B72696768743A307D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D';
wwv_flow_api.g_varchar2_table(48) := '6C2C6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E7069636B2D6172772D6C20697B6C6566743A307D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E706963';
wwv_flow_api.g_varchar2_table(49) := '6B2D6172772E7069636B2D6172772D73322E7069636B2D6172772D727B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582831303025293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465582831303025293B2D6D732D';
wwv_flow_api.g_varchar2_table(50) := '7472616E73666F726D3A7472616E736C617465582831303025293B2D6F2D7472616E73666F726D3A7472616E736C617465582831303025297D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172772E70';
wwv_flow_api.g_varchar2_table(51) := '69636B2D6172772D73322E7069636B2D6172772D6C7B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D31303025293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D31303025293B2D6D732D7472616E73';
wwv_flow_api.g_varchar2_table(52) := '666F726D3A7472616E736C61746558282D31303025293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D31303025297D406D65646961206F6E6C792073637265656E20616E6420286D61782D77696474683A3438307078297B6469762E64';
wwv_flow_api.g_varchar2_table(53) := '61746564726F70706572202E7069636B657220756C2E7069636B202E7069636B2D6172777B2D7765626B69742D7472616E73666F726D3A7363616C652831293B2D6D6F7A2D7472616E73666F726D3A7363616C652831293B2D6D732D7472616E73666F72';
wwv_flow_api.g_varchar2_table(54) := '6D3A7363616C652831293B2D6F2D7472616E73666F726D3A7363616C652831293B6F7061636974793A2E347D7D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D6C2C6469762E6461746564726F7070657220';
wwv_flow_api.g_varchar2_table(55) := '2E7069636B657220756C2E7069636B2E7069636B2D6D2C6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D797B6865696768743A363070783B6C696E652D6865696768743A363070787D6469762E6461746564';
wwv_flow_api.g_varchar2_table(56) := '726F70706572202E7069636B657220756C2E7069636B2E7069636B2D6D7B666F6E742D73697A653A333270787D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D797B666F6E742D73697A653A323470787D64';
wwv_flow_api.g_varchar2_table(57) := '69762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D792E7069636B2D6A756D70202E7069636B2D6172772E7069636B2D6172772D73312E7069636B2D6172772D7220697B72696768743A313670787D6469762E6461';
wwv_flow_api.g_varchar2_table(58) := '746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D792E7069636B2D6A756D70202E7069636B2D6172772E7069636B2D6172772D73312E7069636B2D6172772D6C20697B6C6566743A313670787D6469762E6461746564726F70';
wwv_flow_api.g_varchar2_table(59) := '706572202E7069636B657220756C2E7069636B2E7069636B2D792E7069636B2D6A756D70202E7069636B2D6172772E7069636B2D6172772D73322E7069636B2D6172772D6C2C6469762E6461746564726F70706572202E7069636B657220756C2E706963';
wwv_flow_api.g_varchar2_table(60) := '6B2E7069636B2D792E7069636B2D6A756D70202E7069636B2D6172772E7069636B2D6172772D73322E7069636B2D6172772D727B2D7765626B69742D7472616E73666F726D3A7472616E736C617465582830293B2D6D6F7A2D7472616E73666F726D3A74';
wwv_flow_api.g_varchar2_table(61) := '72616E736C617465582830293B2D6D732D7472616E73666F726D3A7472616E736C617465582830293B2D6F2D7472616E73666F726D3A7472616E736C617465582830297D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E';
wwv_flow_api.g_varchar2_table(62) := '7069636B2D792E7069636B2D6A756D70202E7069636B2D6172773A686F7665727B2D7765626B69742D7472616E73666F726D3A7363616C6528312E36293B2D6D6F7A2D7472616E73666F726D3A7363616C6528312E36293B2D6D732D7472616E73666F72';
wwv_flow_api.g_varchar2_table(63) := '6D3A7363616C6528312E36293B2D6F2D7472616E73666F726D3A7363616C6528312E36297D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D647B6865696768743A31303070783B6C696E652D686569676874';
wwv_flow_api.g_varchar2_table(64) := '3A383070783B666F6E742D73697A653A363470783B666F6E742D7765696768743A3730307D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D6C7B706F736974696F6E3A6162736F6C7574653B626F74746F6D';
wwv_flow_api.g_varchar2_table(65) := '3A303B6C6566743A303B72696768743A303B7A2D696E6465783A31303B666F6E742D73697A653A313870783B666F6E742D7765696768743A3730303B6F7061636974793A303B7669736962696C6974793A68696464656E3B2D7765626B69742D7472616E';
wwv_flow_api.g_varchar2_table(66) := '73666F726D3A7472616E736C617465592833327078293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592833327078293B2D6D732D7472616E73666F726D3A7472616E736C617465592833327078293B2D6F2D7472616E73666F726D3A74';
wwv_flow_api.g_varchar2_table(67) := '72616E736C617465592833327078293B2D7765626B69742D7472616E736974696F6E3A616C6C202E347320656173653B2D6D6F7A2D7472616E736974696F6E3A616C6C202E347320656173653B2D6D732D7472616E736974696F6E3A616C6C202E347320';
wwv_flow_api.g_varchar2_table(68) := '656173653B2D6F2D7472616E736974696F6E3A616C6C202E347320656173657D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D6C2E76697369626C657B6F7061636974793A313B7669736962696C6974793A';
wwv_flow_api.g_varchar2_table(69) := '76697369626C653B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465592830293B2D6D732D7472616E73666F726D3A7472616E736C617465592830293B2D6F2D';
wwv_flow_api.g_varchar2_table(70) := '7472616E73666F726D3A7472616E736C617465592830297D6469762E6461746564726F70706572202E7069636B657220756C2E7069636B3A686F766572202E7069636B2D6172777B6F7061636974793A2E363B2D7765626B69742D7472616E73666F726D';
wwv_flow_api.g_varchar2_table(71) := '3A7363616C652831293B2D6D6F7A2D7472616E73666F726D3A7363616C652831293B2D6D732D7472616E73666F726D3A7363616C652831293B2D6F2D7472616E73666F726D3A7363616C652831297D6469762E6461746564726F70706572202E7069636B';
wwv_flow_api.g_varchar2_table(72) := '657220756C2E7069636B2E7069636B2D643A686F7665722C6469762E6461746564726F70706572202E7069636B657220756C2E7069636B2E7069636B2D793A686F7665727B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E3032';
wwv_flow_api.g_varchar2_table(73) := '297D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C677B7A2D696E6465783A313B6D617267696E3A30206175746F3B6D61782D6865696768743A303B6F766572666C6F773A68696464656E7D6469762E6461746564726F70';
wwv_flow_api.g_varchar2_table(74) := '706572202E7069636B6572202E7069636B2D6C672E646F776E7B616E696D6174696F6E3A646F776E202E387320656173657D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C67202E7069636B2D687B6F7061636974793A2E';
wwv_flow_api.g_varchar2_table(75) := '347D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C3A61667465727B636F6E74656E743A22223B646973706C61793A7461626C653B636C6561723A626F74687D6469762E6461746564726F70706572202E706963';
wwv_flow_api.g_varchar2_table(76) := '6B6572202E7069636B2D6C6720756C206C697B666C6F61743A6C6566743B746578742D616C69676E3A63656E7465723B77696474683A31342E323835373134323836253B6C696E652D6865696768743A333670783B6865696768743A333670783B666F6E';
wwv_flow_api.g_varchar2_table(77) := '742D73697A653A313470787D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D687B70616464696E673A3020313670787D6469762E6461746564726F70706572202E7069636B6572202E7069';
wwv_flow_api.g_varchar2_table(78) := '636B2D6C6720756C2E7069636B2D6C672D627B70616464696E673A313670787D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D62206C697B637572736F723A706F696E7465723B706F7369';
wwv_flow_api.g_varchar2_table(79) := '74696F6E3A72656C61746976653B7A2D696E6465783A317D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D62206C693A6265666F72657B636F6E74656E743A22223B706F736974696F6E3A';
wwv_flow_api.g_varchar2_table(80) := '6162736F6C7574653B7A2D696E6465783A2D313B77696474683A343870783B6865696768743A343870783B626F782D736861646F773A3020302033327078207267626128302C302C302C2E31293B626F726465722D7261646975733A333270783B746F70';
wwv_flow_api.g_varchar2_table(81) := '3A3530253B6C6566743A3530253B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207363616C652830293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207363';
wwv_flow_api.g_varchar2_table(82) := '616C652830293B2D6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207363616C652830293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207363616C652830297D6469762E6461';
wwv_flow_api.g_varchar2_table(83) := '746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D62206C692E7069636B2D763A686F7665727B746578742D6465636F726174696F6E3A756E6465726C696E657D6469762E6461746564726F70706572202E70';
wwv_flow_api.g_varchar2_table(84) := '69636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D62206C692E7069636B2D6C6B3A61667465727B636F6E74656E743A22223B706F736974696F6E3A6162736F6C7574653B746F703A3530253B6C6566743A3470783B72696768743A347078';
wwv_flow_api.g_varchar2_table(85) := '3B6865696768743A3170783B6261636B67726F756E643A7267626128302C302C302C2E32293B2D7765626B69742D7472616E73666F726D3A726F74617465283435646567293B2D6D6F7A2D7472616E73666F726D3A726F74617465283435646567293B2D';
wwv_flow_api.g_varchar2_table(86) := '6D732D7472616E73666F726D3A726F74617465283435646567293B2D6F2D7472616E73666F726D3A726F74617465283435646567297D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D6220';
wwv_flow_api.g_varchar2_table(87) := '6C692E7069636B2D736C7B666F6E742D73697A653A323470787D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D6C6720756C2E7069636B2D6C672D62206C692E7069636B2D736C3A6265666F72657B2D7765626B69742D7472';
wwv_flow_api.g_varchar2_table(88) := '616E73666F726D3A7472616E736C617465282D3530252C2D35302529207363616C652831293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207363616C652831293B2D6D732D7472616E73666F726D3A747261';
wwv_flow_api.g_varchar2_table(89) := '6E736C617465282D3530252C2D35302529207363616C652831293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207363616C652831297D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D';
wwv_flow_api.g_varchar2_table(90) := '62746E737B6D617267696E3A2D3170783B706F736974696F6E3A72656C61746976653B7A2D696E6465783A323B6865696768743A353670787D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73206469767B63757273';
wwv_flow_api.g_varchar2_table(91) := '6F723A706F696E7465723B6C696E652D6865696768743A307D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D7375626D69747B6D617267696E3A30206175746F3B77696474683A353670783B6865';
wwv_flow_api.g_varchar2_table(92) := '696768743A353670783B6C696E652D6865696768743A363470783B626F726465722D7261646975733A353670783B666F6E742D73697A653A323470783B637572736F723A706F696E7465723B626F726465722D626F74746F6D2D6C6566742D7261646975';
wwv_flow_api.g_varchar2_table(93) := '733A303B626F726465722D626F74746F6D2D72696768742D7261646975733A303B746578742D616C69676E3A63656E7465723B706F736974696F6E3A72656C61746976653B746F703A307D6469762E6461746564726F70706572202E7069636B6572202E';
wwv_flow_api.g_varchar2_table(94) := '7069636B2D62746E73202E7069636B2D7375626D69743A61667465727B666F6E742D66616D696C793A6461746564726F7070657221696D706F7274616E743B666F6E742D7374796C653A6E6F726D616C21696D706F7274616E743B666F6E742D77656967';
wwv_flow_api.g_varchar2_table(95) := '68743A34303021696D706F7274616E743B666F6E742D76617269616E743A6E6F726D616C21696D706F7274616E743B746578742D7472616E73666F726D3A6E6F6E6521696D706F7274616E743B737065616B3A6E6F6E653B2D7765626B69742D666F6E74';
wwv_flow_api.g_varchar2_table(96) := '2D736D6F6F7468696E673A616E7469616C69617365643B2D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A677261797363616C653B6C696E652D6865696768743A363070783B636F6E74656E743A225C3635227D6469762E6461746564726F70';
wwv_flow_api.g_varchar2_table(97) := '706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D7375626D69743A686F7665727B746F703A3470783B626F782D736861646F773A30203020302031367078207267626128302C302C302C2E3034292C302030203020387078207267';
wwv_flow_api.g_varchar2_table(98) := '626128302C302C302C2E3034297D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E7B706F736974696F6E3A6162736F6C7574653B77696474683A333270783B6865696768743A333270783B';
wwv_flow_api.g_varchar2_table(99) := '626F74746F6D3A303B746578742D616C69676E3A63656E7465723B6C696E652D6865696768743A333870783B666F6E742D73697A653A313670783B6D617267696E3A3870783B626F726465722D7261646975733A3470783B6261636B67726F756E643A72';
wwv_flow_api.g_varchar2_table(100) := '67626128302C302C302C2E3033297D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E3A686F7665727B6261636B67726F756E643A234646463B2D7765626B69742D626F782D736861646F77';
wwv_flow_api.g_varchar2_table(101) := '3A3020302033327078207267626128302C302C302C2E31293B2D6D6F7A2D626F782D736861646F773A3020302033327078207267626128302C302C302C2E31293B626F782D736861646F773A3020302033327078207267626128302C302C302C2E31293B';
wwv_flow_api.g_varchar2_table(102) := '2D7765626B69742D7472616E73666F726D3A7363616C6528312E32293B2D6D6F7A2D7472616E73666F726D3A7363616C6528312E32293B2D6D732D7472616E73666F726D3A7363616C6528312E32293B2D6F2D7472616E73666F726D3A7363616C652831';
wwv_flow_api.g_varchar2_table(103) := '2E32297D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E3A61667465727B666F6E742D66616D696C793A6461746564726F7070657221696D706F7274616E743B666F6E742D7374796C653A';
wwv_flow_api.g_varchar2_table(104) := '6E6F726D616C21696D706F7274616E743B666F6E742D7765696768743A34303021696D706F7274616E743B666F6E742D76617269616E743A6E6F726D616C21696D706F7274616E743B746578742D7472616E73666F726D3A6E6F6E6521696D706F727461';
wwv_flow_api.g_varchar2_table(105) := '6E743B737065616B3A6E6F6E653B6C696E652D6865696768743A313B2D7765626B69742D666F6E742D736D6F6F7468696E673A616E7469616C69617365643B2D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A677261797363616C657D646976';
wwv_flow_api.g_varchar2_table(106) := '2E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E2E7069636B2D62746E2D737A7B72696768743A303B7472616E73666F726D2D6F726967696E3A726967687420626F74746F6D7D6469762E64617465';
wwv_flow_api.g_varchar2_table(107) := '64726F70706572202E7069636B6572202E7069636B2D62746E73202E7069636B2D62746E2E7069636B2D62746E2D737A3A61667465727B636F6E74656E743A225C3633227D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62';
wwv_flow_api.g_varchar2_table(108) := '746E73202E7069636B2D62746E2E7069636B2D62746E2D6C6E677B6C6566743A303B7472616E73666F726D2D6F726967696E3A6C65667420626F74746F6D7D6469762E6461746564726F70706572202E7069636B6572202E7069636B2D62746E73202E70';
wwv_flow_api.g_varchar2_table(109) := '69636B2D62746E2E7069636B2D62746E2D6C6E673A61667465727B636F6E74656E743A225C3661227D6469762E6461746564726F707065722E7069636B65722D6C677B77696474683A333030707821696D706F7274616E747D6469762E6461746564726F';
wwv_flow_api.g_varchar2_table(110) := '707065722E7069636B65722D6C6720756C2E7069636B2E7069636B2D647B2D7765626B69742D7472616E73666F726D3A7363616C652830293B2D6D6F7A2D7472616E73666F726D3A7363616C652830293B2D6D732D7472616E73666F726D3A7363616C65';
wwv_flow_api.g_varchar2_table(111) := '2830293B2D6F2D7472616E73666F726D3A7363616C652830293B6D61782D6865696768743A3021696D706F7274616E747D6469762E6461746564726F707065722E7069636B65722D6C67202E7069636B2D6C677B6D61782D6865696768743A3332307078';
wwv_flow_api.g_varchar2_table(112) := '7D6469762E6461746564726F707065722E7069636B65722D6C67202E7069636B2D62746E73202E7069636B2D62746E2E7069636B2D62746E2D737A3A61667465727B636F6E74656E743A225C3631227D406D65646961206F6E6C792073637265656E2061';
wwv_flow_api.g_varchar2_table(113) := '6E6420286D61782D77696474683A3438307078297B6469762E6461746564726F707065722E7069636B65722D6C677B706F736974696F6E3A66697865643B746F703A35302521696D706F7274616E743B6C6566743A35302521696D706F7274616E743B2D';
wwv_flow_api.g_varchar2_table(114) := '7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D353025293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D353025293B2D6D732D7472616E73666F726D3A7472616E736C617465282D35';
wwv_flow_api.g_varchar2_table(115) := '30252C2D353025293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D353025293B6D617267696E3A307D6469762E6461746564726F707065722E7069636B65722D6C673A6265666F72657B646973706C61793A6E6F6E657D7D40';
wwv_flow_api.g_varchar2_table(116) := '2D6D6F7A2D6B65796672616D6573207069636B65725F6C6F636B65647B30252C313030257B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30293B2D6D6F7A2D7472616E';
wwv_flow_api.g_varchar2_table(117) := '73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30293B2D6D732D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30293B2D6F2D7472616E73';
wwv_flow_api.g_varchar2_table(118) := '666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30297D3130252C3330252C3530252C3730252C3930257B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E';
wwv_flow_api.g_varchar2_table(119) := '736C6174653364282D3270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364282D3270782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C61746558282D3530';
wwv_flow_api.g_varchar2_table(120) := '2529207472616E736C6174653364282D3270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364282D3270782C302C30297D3230252C3430252C3630252C3830257B2D7765626B6974';
wwv_flow_api.g_varchar2_table(121) := '2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364283270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364283270782C302C30';
wwv_flow_api.g_varchar2_table(122) := '293B2D6D732D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364283270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364283270782C';
wwv_flow_api.g_varchar2_table(123) := '302C30297D7D402D7765626B69742D6B65796672616D6573207069636B65725F6C6F636B65647B30252C313030257B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C3029';
wwv_flow_api.g_varchar2_table(124) := '3B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30293B2D6D732D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30';
wwv_flow_api.g_varchar2_table(125) := '293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30297D3130252C3330252C3530252C3730252C3930257B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655828';
wwv_flow_api.g_varchar2_table(126) := '2D35302529207472616E736C6174653364282D3270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364282D3270782C302C30293B2D6D732D7472616E73666F726D3A7472616E';
wwv_flow_api.g_varchar2_table(127) := '736C61746558282D35302529207472616E736C6174653364282D3270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364282D3270782C302C30297D3230252C3430252C3630252C38';
wwv_flow_api.g_varchar2_table(128) := '30257B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364283270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465';
wwv_flow_api.g_varchar2_table(129) := '3364283270782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364283270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C';
wwv_flow_api.g_varchar2_table(130) := '6174653364283270782C302C30297D7D406B65796672616D6573207069636B65725F6C6F636B65647B30252C313030257B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C';
wwv_flow_api.g_varchar2_table(131) := '30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30293B2D6D732D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C30';
wwv_flow_api.g_varchar2_table(132) := '2C30293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C617465336428302C302C30297D3130252C3330252C3530252C3730252C3930257B2D7765626B69742D7472616E73666F726D3A7472616E736C617465';
wwv_flow_api.g_varchar2_table(133) := '58282D35302529207472616E736C6174653364282D3270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364282D3270782C302C30293B2D6D732D7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(134) := '616E736C61746558282D35302529207472616E736C6174653364282D3270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364282D3270782C302C30297D3230252C3430252C363025';
wwv_flow_api.g_varchar2_table(135) := '2C3830257B2D7765626B69742D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364283270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C61';
wwv_flow_api.g_varchar2_table(136) := '74653364283270782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E736C6174653364283270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C61746558282D35302529207472616E';
wwv_flow_api.g_varchar2_table(137) := '736C6174653364283270782C302C30297D7D402D6D6F7A2D6B65796672616D6573207069636B65725F6C6F636B65645F6C617267655F6D6F62696C657B30252C313030257B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530';
wwv_flow_api.g_varchar2_table(138) := '252C2D35302529207472616E736C617465336428302C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C617465336428302C302C30293B2D6D732D7472616E73666F726D3A7472616E';
wwv_flow_api.g_varchar2_table(139) := '736C617465282D3530252C2D35302529207472616E736C617465336428302C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C617465336428302C302C30297D3130252C3330252C353025';
wwv_flow_api.g_varchar2_table(140) := '2C3730252C3930257B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C';
wwv_flow_api.g_varchar2_table(141) := '2D35302529207472616E736C6174653364282D3270782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C302C30293B2D6F2D7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(142) := '616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C302C30297D3230252C3430252C3630252C3830257B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E';
wwv_flow_api.g_varchar2_table(143) := '736C6174653364283270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364283270782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C617465282D35';
wwv_flow_api.g_varchar2_table(144) := '30252C2D35302529207472616E736C6174653364283270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364283270782C302C30297D7D402D7765626B69742D6B65796672';
wwv_flow_api.g_varchar2_table(145) := '616D6573207069636B65725F6C6F636B65645F6C617267655F6D6F62696C657B30252C313030257B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C617465336428302C302C30293B2D6D';
wwv_flow_api.g_varchar2_table(146) := '6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C617465336428302C302C30293B2D6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C617465336428';
wwv_flow_api.g_varchar2_table(147) := '302C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C617465336428302C302C30297D3130252C3330252C3530252C3730252C3930257B2D7765626B69742D7472616E73666F726D3A7472';
wwv_flow_api.g_varchar2_table(148) := '616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C302C30293B2D';
wwv_flow_api.g_varchar2_table(149) := '6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C61746533';
wwv_flow_api.g_varchar2_table(150) := '64282D3270782C302C30297D3230252C3430252C3630252C3830257B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364283270782C302C30293B2D6D6F7A2D7472616E73666F';
wwv_flow_api.g_varchar2_table(151) := '726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364283270782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364283270782C302C3029';
wwv_flow_api.g_varchar2_table(152) := '3B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364283270782C302C30297D7D406B65796672616D6573207069636B65725F6C6F636B65645F6C617267655F6D6F62696C657B30252C3130';
wwv_flow_api.g_varchar2_table(153) := '30257B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C617465336428302C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D3530252920747261';
wwv_flow_api.g_varchar2_table(154) := '6E736C617465336428302C302C30293B2D6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C617465336428302C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35';
wwv_flow_api.g_varchar2_table(155) := '302529207472616E736C617465336428302C302C30297D3130252C3330252C3530252C3730252C3930257B2D7765626B69742D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C30';
wwv_flow_api.g_varchar2_table(156) := '2C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D3530252920747261';
wwv_flow_api.g_varchar2_table(157) := '6E736C6174653364282D3270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364282D3270782C302C30297D3230252C3430252C3630252C3830257B2D7765626B69742D74';
wwv_flow_api.g_varchar2_table(158) := '72616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364283270782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C61746533642832';
wwv_flow_api.g_varchar2_table(159) := '70782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472616E736C6174653364283270782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465282D3530252C2D35302529207472';
wwv_flow_api.g_varchar2_table(160) := '616E736C6174653364283270782C302C30297D7D6469762E6461746564726F707065722E7069636B65722D726D626C7B2D7765626B69742D616E696D6174696F6E3A7069636B65725F6C6F636B6564202E347320656173653B2D6D6F7A2D616E696D6174';
wwv_flow_api.g_varchar2_table(161) := '696F6E3A7069636B65725F6C6F636B6564202E347320656173653B616E696D6174696F6E3A7069636B65725F6C6F636B6564202E347320656173657D406D65646961206F6E6C792073637265656E20616E6420286D61782D77696474683A343830707829';
wwv_flow_api.g_varchar2_table(162) := '7B6469762E6461746564726F707065722E7069636B65722D726D626C2E7069636B65722D6C677B2D7765626B69742D616E696D6174696F6E3A7069636B65725F6C6F636B65645F6C617267655F6D6F62696C65202E347320656173653B2D6D6F7A2D616E';
wwv_flow_api.g_varchar2_table(163) := '696D6174696F6E3A7069636B65725F6C6F636B65645F6C617267655F6D6F62696C65202E347320656173653B616E696D6174696F6E3A7069636B65725F6C6F636B65645F6C617267655F6D6F62696C65202E347320656173657D7D6469762E6461746564';
wwv_flow_api.g_varchar2_table(164) := '726F707065722E7069636B65722D6C6B64202E7069636B2D7375626D69747B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E30342921696D706F7274616E743B636F6C6F723A7267626128302C302C302C2E322921696D706F72';
wwv_flow_api.g_varchar2_table(165) := '74616E747D6469762E6461746564726F707065722E7069636B65722D6C6B64202E7069636B2D7375626D69743A686F7665727B2D7765626B69742D626F782D736861646F773A6E6F6E6521696D706F7274616E743B2D6D6F7A2D626F782D736861646F77';
wwv_flow_api.g_varchar2_table(166) := '3A6E6F6E6521696D706F7274616E743B626F782D736861646F773A6E6F6E6521696D706F7274616E747D6469762E6461746564726F707065722E7069636B65722D6C6B64202E7069636B2D7375626D69743A61667465727B636F6E74656E743A225C3632';
wwv_flow_api.g_varchar2_table(167) := '2221696D706F7274616E747D6469762E6461746564726F707065722E7069636B65722D6678737B2D7765626B69742D7472616E736974696F6E3A7769647468202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C6F7061';
wwv_flow_api.g_varchar2_table(168) := '63697479202E327320656173652C7669736962696C697479202E327320656173652C6D617267696E202E327320656173653B2D6D6F7A2D7472616E736974696F6E3A7769647468202E38732063756269632D62657A69657228312C2D2E35352C2E322C31';
wwv_flow_api.g_varchar2_table(169) := '2E3337292C6F706163697479202E327320656173652C7669736962696C697479202E327320656173652C6D617267696E202E327320656173653B2D6D732D7472616E736974696F6E3A7769647468202E38732063756269632D62657A69657228312C2D2E';
wwv_flow_api.g_varchar2_table(170) := '35352C2E322C312E3337292C6F706163697479202E327320656173652C7669736962696C697479202E327320656173652C6D617267696E202E327320656173653B2D6F2D7472616E736974696F6E3A7769647468202E38732063756269632D62657A6965';
wwv_flow_api.g_varchar2_table(171) := '7228312C2D2E35352C2E322C312E3337292C6F706163697479202E327320656173652C7669736962696C697479202E327320656173652C6D617267696E202E327320656173657D6469762E6461746564726F707065722E7069636B65722D66787320756C';
wwv_flow_api.g_varchar2_table(172) := '2E7069636B2E7069636B2D647B2D7765626B69742D7472616E736974696F6E3A746F70202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C7472616E73666F726D202E38732063756269632D62657A69657228312C2D2E';
wwv_flow_api.g_varchar2_table(173) := '35352C2E322C312E3337292C6D61782D686569676874202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C6261636B67726F756E642D636F6C6F72202E347320656173653B2D6D6F7A2D7472616E736974696F6E3A746F';
wwv_flow_api.g_varchar2_table(174) := '70202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C7472616E73666F726D202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C6D61782D686569676874202E38732063756269632D62';
wwv_flow_api.g_varchar2_table(175) := '657A69657228312C2D2E35352C2E322C312E3337292C6261636B67726F756E642D636F6C6F72202E347320656173653B2D6D732D7472616E736974696F6E3A746F70202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C';
wwv_flow_api.g_varchar2_table(176) := '7472616E73666F726D202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C6D61782D686569676874202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C6261636B67726F756E642D636F';
wwv_flow_api.g_varchar2_table(177) := '6C6F72202E347320656173653B2D6F2D7472616E736974696F6E3A746F70202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C7472616E73666F726D202E38732063756269632D62657A69657228312C2D2E35352C2E32';
wwv_flow_api.g_varchar2_table(178) := '2C312E3337292C6D61782D686569676874202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337292C6261636B67726F756E642D636F6C6F72202E347320656173657D6469762E6461746564726F707065722E7069636B65722D';
wwv_flow_api.g_varchar2_table(179) := '66787320756C2E7069636B2E7069636B2D797B2D7765626B69742D7472616E736974696F6E3A6261636B67726F756E642D636F6C6F72202E347320656173653B2D6D6F7A2D7472616E736974696F6E3A6261636B67726F756E642D636F6C6F72202E3473';
wwv_flow_api.g_varchar2_table(180) := '20656173653B2D6D732D7472616E736974696F6E3A6261636B67726F756E642D636F6C6F72202E347320656173653B2D6F2D7472616E736974696F6E3A6261636B67726F756E642D636F6C6F72202E347320656173657D6469762E6461746564726F7070';
wwv_flow_api.g_varchar2_table(181) := '65722E7069636B65722D66787320756C2E7069636B206C697B2D7765626B69742D7472616E736974696F6E3A7472616E73666F726D202E347320656173652C6F706163697479202E347320656173653B2D6D6F7A2D7472616E736974696F6E3A7472616E';
wwv_flow_api.g_varchar2_table(182) := '73666F726D202E347320656173652C6F706163697479202E347320656173653B2D6D732D7472616E736974696F6E3A7472616E73666F726D202E347320656173652C6F706163697479202E347320656173653B2D6F2D7472616E736974696F6E3A747261';
wwv_flow_api.g_varchar2_table(183) := '6E73666F726D202E347320656173652C6F706163697479202E347320656173657D6469762E6461746564726F707065722E7069636B65722D66787320756C2E7069636B202E7069636B2D6172777B2D7765626B69742D7472616E736974696F6E3A747261';
wwv_flow_api.g_varchar2_table(184) := '6E73666F726D202E327320656173652C6F706163697479202E327320656173653B2D6D6F7A2D7472616E736974696F6E3A7472616E73666F726D202E327320656173652C6F706163697479202E327320656173653B2D6D732D7472616E736974696F6E3A';
wwv_flow_api.g_varchar2_table(185) := '7472616E73666F726D202E327320656173652C6F706163697479202E327320656173653B2D6F2D7472616E736974696F6E3A7472616E73666F726D202E327320656173652C6F706163697479202E327320656173657D6469762E6461746564726F707065';
wwv_flow_api.g_varchar2_table(186) := '722E7069636B65722D66787320756C2E7069636B202E7069636B2D61727720697B2D7765626B69742D7472616E736974696F6E3A7269676874202E327320656173652C6C656674202E327320656173653B2D6D6F7A2D7472616E736974696F6E3A726967';
wwv_flow_api.g_varchar2_table(187) := '6874202E327320656173652C6C656674202E327320656173653B2D6D732D7472616E736974696F6E3A7269676874202E327320656173652C6C656674202E327320656173653B2D6F2D7472616E736974696F6E3A7269676874202E327320656173652C6C';
wwv_flow_api.g_varchar2_table(188) := '656674202E327320656173657D6469762E6461746564726F707065722E7069636B65722D667873202E7069636B2D6C677B2D7765626B69742D7472616E736974696F6E3A6D61782D686569676874202E38732063756269632D62657A69657228312C2D2E';
wwv_flow_api.g_varchar2_table(189) := '35352C2E322C312E3337293B2D6D6F7A2D7472616E736974696F6E3A6D61782D686569676874202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337293B2D6D732D7472616E736974696F6E3A6D61782D686569676874202E38';
wwv_flow_api.g_varchar2_table(190) := '732063756269632D62657A69657228312C2D2E35352C2E322C312E3337293B2D6F2D7472616E736974696F6E3A6D61782D686569676874202E38732063756269632D62657A69657228312C2D2E35352C2E322C312E3337297D6469762E6461746564726F';
wwv_flow_api.g_varchar2_table(191) := '707065722E7069636B65722D667873202E7069636B2D6C67202E7069636B2D6C672D62206C693A6265666F72657B2D7765626B69742D7472616E736974696F6E3A7472616E73666F726D202E327320656173653B2D6D6F7A2D7472616E736974696F6E3A';
wwv_flow_api.g_varchar2_table(192) := '7472616E73666F726D202E327320656173653B2D6D732D7472616E736974696F6E3A7472616E73666F726D202E327320656173653B2D6F2D7472616E736974696F6E3A7472616E73666F726D202E327320656173657D6469762E6461746564726F707065';
wwv_flow_api.g_varchar2_table(193) := '722E7069636B65722D667873202E7069636B2D62746E73202E7069636B2D7375626D69747B2D7765626B69742D7472616E736974696F6E3A746F70202E327320656173652C626F782D736861646F77202E347320656173652C6261636B67726F756E642D';
wwv_flow_api.g_varchar2_table(194) := '636F6C6F72202E347320656173653B2D6D6F7A2D7472616E736974696F6E3A746F70202E327320656173652C626F782D736861646F77202E347320656173652C6261636B67726F756E642D636F6C6F72202E347320656173653B2D6D732D7472616E7369';
wwv_flow_api.g_varchar2_table(195) := '74696F6E3A746F70202E327320656173652C626F782D736861646F77202E347320656173652C6261636B67726F756E642D636F6C6F72202E347320656173653B2D6F2D7472616E736974696F6E3A746F70202E327320656173652C626F782D736861646F';
wwv_flow_api.g_varchar2_table(196) := '77202E347320656173652C6261636B67726F756E642D636F6C6F72202E347320656173657D6469762E6461746564726F707065722E7069636B65722D667873202E7069636B2D62746E73202E7069636B2D62746E7B2D7765626B69742D7472616E736974';
wwv_flow_api.g_varchar2_table(197) := '696F6E3A616C6C202E327320656173653B2D6D6F7A2D7472616E736974696F6E3A616C6C202E327320656173653B2D6D732D7472616E736974696F6E3A616C6C202E327320656173653B2D6F2D7472616E736974696F6E3A616C6C202E32732065617365';
wwv_flow_api.g_varchar2_table(198) := '7D406D65646961206F6E6C792073637265656E20616E6420286D61782D77696474683A3438307078297B6469762E6461746564726F707065722E7069636B65722D6678737B2D7765626B69742D7472616E736974696F6E3A6F706163697479202E327320';
wwv_flow_api.g_varchar2_table(199) := '656173652C7669736962696C697479202E327320656173652C6D617267696E202E327320656173653B2D6D6F7A2D7472616E736974696F6E3A6F706163697479202E327320656173652C7669736962696C697479202E327320656173652C6D617267696E';
wwv_flow_api.g_varchar2_table(200) := '202E327320656173653B2D6D732D7472616E736974696F6E3A6F706163697479202E327320656173652C7669736962696C697479202E327320656173652C6D617267696E202E327320656173653B2D6F2D7472616E736974696F6E3A6F70616369747920';
wwv_flow_api.g_varchar2_table(201) := '2E327320656173652C7669736962696C697479202E327320656173652C6D617267696E202E327320656173657D6469762E6461746564726F707065722E7069636B65722D667873202E7069636B2D6C672C6469762E6461746564726F707065722E706963';
wwv_flow_api.g_varchar2_table(202) := '6B65722D66787320756C2E7069636B2E7069636B2D647B2D7765626B69742D7472616E736974696F6E3A6E6F6E653B2D6D6F7A2D7472616E736974696F6E3A6E6F6E653B2D6D732D7472616E736974696F6E3A6E6F6E653B2D6F2D7472616E736974696F';
wwv_flow_api.g_varchar2_table(203) := '6E3A6E6F6E657D7D6469762E6461746564726F707065722E76616E696C6C617B626F726465722D7261646975733A3670783B77696474683A31383070787D6469762E6461746564726F707065722E76616E696C6C61202E7069636B65727B626F72646572';
wwv_flow_api.g_varchar2_table(204) := '2D7261646975733A3670783B626F782D736861646F773A30203020333270782030207267626128302C302C302C2E31297D6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C7B626F726465722D626F74746F6D2D6C6566742D';
wwv_flow_api.g_varchar2_table(205) := '7261646975733A3670783B626F726465722D626F74746F6D2D72696768742D7261646975733A3670787D6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C672D62202E7069636B2D736C3A6265666F72652C6469762E646174';
wwv_flow_api.g_varchar2_table(206) := '6564726F707065722E76616E696C6C61202E7069636B2D6C672D682C6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6D2C6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D7375626D69742C646976';
wwv_flow_api.g_varchar2_table(207) := '2E6461746564726F707065722E76616E696C6C613A6265666F72657B6261636B67726F756E642D636F6C6F723A236665616339327D6469762E6461746564726F707065722E76616E696C6C61202E7069636B206C69207370616E2C6469762E6461746564';
wwv_flow_api.g_varchar2_table(208) := '726F707065722E76616E696C6C61202E7069636B2D62746E2C6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C672D62202E7069636B2D776B652C6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D';
wwv_flow_api.g_varchar2_table(209) := '792E7069636B2D6A756D707B636F6C6F723A236665616339327D6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C2C6469762E6461746564726F707065722E76616E696C6C61202E7069636B65727B6261636B67726F756E64';
wwv_flow_api.g_varchar2_table(210) := '2D636F6C6F723A236666667D6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6172772C6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C2C6469762E6461746564726F707065722E76616E696C6C';
wwv_flow_api.g_varchar2_table(211) := '61202E7069636B65727B636F6C6F723A233965643764627D6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C672D62202E7069636B2D736C2C6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6C67';
wwv_flow_api.g_varchar2_table(212) := '2D682C6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6D2C6469762E6461746564726F707065722E76616E696C6C61202E7069636B2D6D202E7069636B2D6172772C6469762E6461746564726F707065722E76616E696C6C61';
wwv_flow_api.g_varchar2_table(213) := '202E7069636B2D7375626D69747B636F6C6F723A236661663766347D6469762E6461746564726F707065722E76616E696C6C612E7069636B65722D74696E79202E7069636B2D6D2C6469762E6461746564726F707065722E76616E696C6C612E7069636B';
wwv_flow_api.g_varchar2_table(214) := '65722D74696E793A6265666F72657B6261636B67726F756E642D636F6C6F723A236666667D6469762E6461746564726F707065722E76616E696C6C612E7069636B65722D74696E79202E7069636B2D6D2C6469762E6461746564726F707065722E76616E';
wwv_flow_api.g_varchar2_table(215) := '696C6C612E7069636B65722D74696E79202E7069636B2D6D202E7069636B2D6172777B636F6C6F723A233965643764627D6469762E6461746564726F707065722E6C6561667B626F726465722D7261646975733A3670783B77696474683A31383070787D';
wwv_flow_api.g_varchar2_table(216) := '6469762E6461746564726F707065722E6C656166202E7069636B65727B626F726465722D7261646975733A3670783B626F782D736861646F773A30203020333270782030207267626128302C302C302C2E31297D6469762E6461746564726F707065722E';
wwv_flow_api.g_varchar2_table(217) := '6C656166202E7069636B2D6C7B626F726465722D626F74746F6D2D6C6566742D7261646975733A3670783B626F726465722D626F74746F6D2D72696768742D7261646975733A3670787D6469762E6461746564726F707065722E6C656166202E7069636B';
wwv_flow_api.g_varchar2_table(218) := '2D6C672D62202E7069636B2D736C3A6265666F72652C6469762E6461746564726F707065722E6C656166202E7069636B2D6C672D682C6469762E6461746564726F707065722E6C656166202E7069636B2D6D2C6469762E6461746564726F707065722E6C';
wwv_flow_api.g_varchar2_table(219) := '656166202E7069636B2D7375626D69742C6469762E6461746564726F707065722E6C6561663A6265666F72657B6261636B67726F756E642D636F6C6F723A233165636438307D6469762E6461746564726F707065722E6C656166202E7069636B206C6920';
wwv_flow_api.g_varchar2_table(220) := '7370616E2C6469762E6461746564726F707065722E6C656166202E7069636B2D62746E2C6469762E6461746564726F707065722E6C656166202E7069636B2D6C672D62202E7069636B2D776B652C6469762E6461746564726F707065722E6C656166202E';
wwv_flow_api.g_varchar2_table(221) := '7069636B2D792E7069636B2D6A756D707B636F6C6F723A233165636438307D6469762E6461746564726F707065722E6C656166202E7069636B2D6C2C6469762E6461746564726F707065722E6C656166202E7069636B65727B6261636B67726F756E642D';
wwv_flow_api.g_varchar2_table(222) := '636F6C6F723A236665666666327D6469762E6461746564726F707065722E6C656166202E7069636B2D6172772C6469762E6461746564726F707065722E6C656166202E7069636B2D6C2C6469762E6461746564726F707065722E6C656166202E7069636B';
wwv_flow_api.g_varchar2_table(223) := '65727B636F6C6F723A233532383937317D6469762E6461746564726F707065722E6C656166202E7069636B2D6C672D62202E7069636B2D736C2C6469762E6461746564726F707065722E6C656166202E7069636B2D6C672D682C6469762E646174656472';
wwv_flow_api.g_varchar2_table(224) := '6F707065722E6C656166202E7069636B2D6D2C6469762E6461746564726F707065722E6C656166202E7069636B2D6D202E7069636B2D6172772C6469762E6461746564726F707065722E6C656166202E7069636B2D7375626D69747B636F6C6F723A2366';
wwv_flow_api.g_varchar2_table(225) := '65666666327D6469762E6461746564726F707065722E6C6561662E7069636B65722D74696E79202E7069636B2D6D2C6469762E6461746564726F707065722E6C6561662E7069636B65722D74696E793A6265666F72657B6261636B67726F756E642D636F';
wwv_flow_api.g_varchar2_table(226) := '6C6F723A236665666666327D6469762E6461746564726F707065722E6C6561662E7069636B65722D74696E79202E7069636B2D6D2C6469762E6461746564726F707065722E6C6561662E7069636B65722D74696E79202E7069636B2D6D202E7069636B2D';
wwv_flow_api.g_varchar2_table(227) := '6172777B636F6C6F723A233532383937317D6469762E6461746564726F707065722E7072696D6172797B626F726465722D7261646975733A3670783B77696474683A31383070787D6469762E6461746564726F707065722E7072696D617279202E706963';
wwv_flow_api.g_varchar2_table(228) := '6B65727B626F726465722D7261646975733A3670783B626F782D736861646F773A30203020333270782030207267626128302C302C302C2E31297D6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C7B626F726465722D626F';
wwv_flow_api.g_varchar2_table(229) := '74746F6D2D6C6566742D7261646975733A3670783B626F726465722D626F74746F6D2D72696768742D7261646975733A3670787D6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C672D62202E7069636B2D736C3A6265666F';
wwv_flow_api.g_varchar2_table(230) := '72652C6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C672D682C6469762E6461746564726F707065722E7072696D617279202E7069636B2D6D2C6469762E6461746564726F707065722E7072696D617279202E7069636B2D';
wwv_flow_api.g_varchar2_table(231) := '7375626D69742C6469762E6461746564726F707065722E7072696D6172793A6265666F72657B6261636B67726F756E642D636F6C6F723A236664343734317D6469762E6461746564726F707065722E7072696D617279202E7069636B206C69207370616E';
wwv_flow_api.g_varchar2_table(232) := '2C6469762E6461746564726F707065722E7072696D617279202E7069636B2D62746E2C6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C672D62202E7069636B2D776B652C6469762E6461746564726F707065722E7072696D';
wwv_flow_api.g_varchar2_table(233) := '617279202E7069636B2D792E7069636B2D6A756D707B636F6C6F723A236664343734317D6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C2C6469762E6461746564726F707065722E7072696D617279202E7069636B65727B';
wwv_flow_api.g_varchar2_table(234) := '6261636B67726F756E642D636F6C6F723A236666667D6469762E6461746564726F707065722E7072696D617279202E7069636B2D6172772C6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C2C6469762E6461746564726F70';
wwv_flow_api.g_varchar2_table(235) := '7065722E7072696D617279202E7069636B65727B636F6C6F723A233464346434647D6469762E6461746564726F707065722E7072696D617279202E7069636B2D6C672D62202E7069636B2D736C2C6469762E6461746564726F707065722E7072696D6172';
wwv_flow_api.g_varchar2_table(236) := '79202E7069636B2D6C672D682C6469762E6461746564726F707065722E7072696D617279202E7069636B2D6D2C6469762E6461746564726F707065722E7072696D617279202E7069636B2D6D202E7069636B2D6172772C6469762E6461746564726F7070';
wwv_flow_api.g_varchar2_table(237) := '65722E7072696D617279202E7069636B2D7375626D69747B636F6C6F723A236666667D6469762E6461746564726F707065722E7072696D6172792E7069636B65722D74696E79202E7069636B2D6D2C6469762E6461746564726F707065722E7072696D61';
wwv_flow_api.g_varchar2_table(238) := '72792E7069636B65722D74696E793A6265666F72657B6261636B67726F756E642D636F6C6F723A236666667D6469762E6461746564726F707065722E7072696D6172792E7069636B65722D74696E79202E7069636B2D6D2C6469762E6461746564726F70';
wwv_flow_api.g_varchar2_table(239) := '7065722E7072696D6172792E7069636B65722D74696E79202E7069636B2D6D202E7069636B2D6172777B636F6C6F723A233464346434647D6469762E6461746564726F70706572202E6E756C6C7B2D7765626B69742D7472616E736974696F6E3A6E6F6E';
wwv_flow_api.g_varchar2_table(240) := '653B2D6D6F7A2D7472616E736974696F6E3A6E6F6E653B2D6D732D7472616E736974696F6E3A6E6F6E653B2D6F2D7472616E736974696F6E3A6E6F6E657D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395084907947574696)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/lib/Datedropper3/datedropper.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E2865297B76617220613D7B743A227472616E736974696F6E656E64207765626B69745472616E736974696F6E456E64206F5472616E736974696F6E456E64206F7472616E736974696F6E656E64204D535472616E736974696F6E45';
wwv_flow_api.g_varchar2_table(2) := '6E64222C613A227765626B6974416E696D6174696F6E456E64206D6F7A416E696D6174696F6E456E64206F416E696D6174696F6E456E64206F616E696D6174696F6E656E6420616E696D6174696F6E656E64227D2C743D7B656E3A7B6E616D653A22456E';
wwv_flow_api.g_varchar2_table(3) := '676C697368222C677265676F7269616E3A21312C6D6F6E7468733A7B2273686F7274223A5B224A616E222C22466562222C224D6172222C22417072222C224D6179222C224A756E65222C224A756C79222C22417567222C2253657074222C224F6374222C';
wwv_flow_api.g_varchar2_table(4) := '224E6F76222C22446563225D2C66756C6C3A5B224A616E75617279222C224665627275617279222C224D61726368222C22417072696C222C224D6179222C224A756E65222C224A756C79222C22417567757374222C2253657074656D626572222C224F63';
wwv_flow_api.g_varchar2_table(5) := '746F626572222C224E6F76656D626572222C22446563656D626572225D7D2C7765656B646179733A7B2273686F7274223A5B2253222C224D222C2254222C2257222C2254222C2246222C2253225D2C66756C6C3A5B2253756E646179222C224D6F6E6461';
wwv_flow_api.g_varchar2_table(6) := '79222C2254756573646179222C225765646E6573646179222C225468757273646179222C22467269646179222C225361747572646179225D7D7D2C69743A7B6E616D653A224974616C69616E6F222C677265676F7269616E3A21302C6D6F6E7468733A7B';
wwv_flow_api.g_varchar2_table(7) := '2273686F7274223A5B2247656E222C22466562222C224D6172222C22417072222C224D6167222C22476975222C224C7567222C2241676F222C22536574222C224F7474222C224E6F76222C22446963225D2C66756C6C3A5B2247656E6E61696F222C2246';
wwv_flow_api.g_varchar2_table(8) := '6562627261696F222C224D61727A6F222C22417072696C65222C224D616767696F222C22476975676E6F222C224C75676C696F222C2241676F73746F222C2253657474656D627265222C224F74746F627265222C224E6F76656D627265222C2244696365';
wwv_flow_api.g_varchar2_table(9) := '6D627265225D7D2C7765656B646179733A7B2273686F7274223A5B2244222C224C222C224D222C224D222C2247222C2256222C2253225D2C66756C6C3A5B22446F6D656E696361222C224C756E6564C3AC222C224D6172746564C3AC222C224D6572636F';
wwv_flow_api.g_varchar2_table(10) := '6C6564C3AC222C2247696F766564C3AC222C2256656E657264C3AC222C2253616261746F225D7D7D2C66723A7B6E616D653A224672616EC3A7616973222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B224A616E222C2246';
wwv_flow_api.g_varchar2_table(11) := 'C3A976222C224D6172222C22417672222C224D6169222C224A7569222C224A7569222C22416FC3BB222C22536570222C224F6374222C224E6F76222C2244C3A963225D2C66756C6C3A5B224A616E76696572222C2246C3A97672696572222C224D617273';
wwv_flow_api.g_varchar2_table(12) := '222C22417672696C222C224D6169222C224A75696E222C224A75696C6C6574222C22416FC3BB74222C2253657074656D627265222C224F63746F627265222C224E6F76656D627265222C2244C3A963656D627265225D7D2C7765656B646179733A7B2273';
wwv_flow_api.g_varchar2_table(13) := '686F7274223A5B2244222C224C222C224D222C224D222C224A222C2256222C2253225D2C66756C6C3A5B2244696D616E636865222C224C756E6469222C224D61726469222C224D65726372656469222C224A65756469222C2256656E6472656469222C22';
wwv_flow_api.g_varchar2_table(14) := '53616D656469225D7D7D2C7A683A7B6E616D653A22E4B8ADE69687222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B22E4B880E69C88222C22E4BA8CE69C88222C22E4B889E69C88222C22E59B9BE69C88222C22E4BA94E6';
wwv_flow_api.g_varchar2_table(15) := '9C88222C22E585ADE69C88222C22E4B883E69C88222C22E585ABE69C88222C22E4B99DE69C88222C22E58D81E69C88222C22E58D81E4B880E69C88222C22E58D81E4BA8CE69C88225D2C66756C6C3A5B22E4B880E69C88222C22E4BA8CE69C88222C22E4';
wwv_flow_api.g_varchar2_table(16) := 'B889E69C88222C22E59B9BE69C88222C22E4BA94E69C88222C22E585ADE69C88222C22E4B883E69C88222C22E585ABE69C88222C22E4B99DE69C88222C22E58D81E69C88222C22E58D81E4B880E69C88222C22E58D81E4BA8CE69C88225D7D2C7765656B';
wwv_flow_api.g_varchar2_table(17) := '646179733A7B2273686F7274223A5B22E5A4A9222C22E4B880222C22E4BA8C222C22E4B889222C22E59B9B222C22E4BA94222C22E585AD225D2C66756C6C3A5B22E6989FE69C9FE5A4A9222C22E6989FE69C9FE4B880222C22E6989FE69C9FE4BA8C222C';
wwv_flow_api.g_varchar2_table(18) := '22E6989FE69C9FE4B889222C22E6989FE69C9FE59B9B222C22E6989FE69C9FE4BA94222C22E6989FE69C9FE585AD225D7D7D2C61723A7B6E616D653A22D8A7D984D8B9D98ED8B1D98ED8A8D990D98AD98ED991D8A9222C677265676F7269616E3A21312C';
wwv_flow_api.g_varchar2_table(19) := '6D6F6E7468733A7B2273686F7274223A5B22D8ACD8A7D986D981D98A222C22D981D98AD981D8B1D98A222C22D985D8A7D8B1D8B3222C22D8A3D981D8B1D98AD984222C22D985D8A7D98A222C22D8ACD988D8A7D986222C22D8ACD988D98AD984D98AD8A9';
wwv_flow_api.g_varchar2_table(20) := '222C22D8A3D988D8AA222C22D8B3D8A8D8AAD985D8A8D8B1222C22D8A3D983D8AAD988D8A8D8B1222C22D986D988D981D985D8A8D8B1222C22D8AFD98AD8B3D985D8A8D8B1225D2C66756C6C3A5B22D8ACD8A7D986D981D98A222C22D981D98AD981D8B1';
wwv_flow_api.g_varchar2_table(21) := 'D98A222C22D985D8A7D8B1D8B3222C22D8A3D981D8B1D98AD984222C22D985D8A7D98A222C22D8ACD988D8A7D986222C22D8ACD988D98AD984D98AD8A9222C22D8A3D988D8AA222C22D8B3D8A8D8AAD985D8A8D8B1222C22D8A3D983D8AAD988D8A8D8B1';
wwv_flow_api.g_varchar2_table(22) := '222C22D986D988D981D985D8A8D8B1222C22D8AFD98AD8B3D985D8A8D8B1225D7D2C7765656B646179733A7B2273686F7274223A5B2253222C224D222C2254222C2257222C2254222C2246222C2253225D2C66756C6C3A5B22D8A7D984D8A3D8ADD8AF22';
wwv_flow_api.g_varchar2_table(23) := '2C22D8A7D984D8A5D8ABD986D98AD986222C22D8A7D984D8ABD984D8ABD8A7D8A1222C22D8A7D984D8A3D8B1D8A8D8B9D8A7D8A1222C22D8A7D984D8AED985D98AD8B3222C22D8A7D984D8ACD985D8B9D8A9222C22D8A7D984D8B3D8A8D8AA225D7D7D2C';
wwv_flow_api.g_varchar2_table(24) := '66613A7B6E616D653A22D981D8A7D8B1D8B3DB8C222C677265676F7269616E3A21312C6D6F6E7468733A7B2273686F7274223A5B22DA98D8A7D986D988DB8CD987222C22D981D988D988D8B1DB8CD987222C22D985D8A7D8B1DA86222C22D8A2D9BED8B1';
wwv_flow_api.g_varchar2_table(25) := 'DB8CD984222C22D985DB8C222C22D8ACD988D986222C22D8ACD988D984D8A7DB8C222C22D8A2DAAFD988D8B3D8AA222C22D8B3D9BED8AAD8A7D985D8A8D8B1222C22D8A7DAA9D8AAD8A8D8B1222C22D986D988D8A7D985D8A8D8B1222C22D8AFD8B3D8A7';
wwv_flow_api.g_varchar2_table(26) := 'D985D8A8D8B1225D2C66756C6C3A5B22DA98D8A7D986D988DB8CD987222C22D981D988D988D8B1DB8CD987222C22D985D8A7D8B1DA86222C22D8A2D9BED8B1DB8CD984222C22D985DB8C222C22D8ACD988D986222C22D8ACD988D984D8A7DB8C222C22D8';
wwv_flow_api.g_varchar2_table(27) := 'A2DAAFD988D8B3D8AA222C22D8B3D9BED8AAD8A7D985D8A8D8B1222C22D8A7DAA9D8AAD8A8D8B1222C22D986D988D8A7D985D8A8D8B1222C22D8AFD8B3D8A7D985D8A8D8B1225D7D2C7765656B646179733A7B2273686F7274223A5B2253222C224D222C';
wwv_flow_api.g_varchar2_table(28) := '2254222C2257222C2254222C2246222C2253225D2C66756C6C3A5B22DB8CDAA9D8B4D986D8A8D987222C22D8AFD988D8B4D986D8A8D987222C22D8B3D98720D8B4D986D8A8D987222C22DA86D987D8A7D8B1D8B4D986D8A8D987222C22D9BED986D8AC20';
wwv_flow_api.g_varchar2_table(29) := 'D8B4D986D8A8D987222C22D8ACD985D8B9D987222C22D8B4D986D8A8D987225D7D7D2C68753A7B6E616D653A2248756E67617269616E222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B226A616E222C22666562222C226D';
wwv_flow_api.g_varchar2_table(30) := 'C3A172222C22C3A17072222C226DC3A16A222C226AC3BA6E222C226AC3BA6C222C22617567222C22737A65222C226F6B74222C226E6F76222C22646563225D2C66756C6C3A5B226A616E75C3A172222C226665627275C3A172222C226DC3A17263697573';
wwv_flow_api.g_varchar2_table(31) := '222C22C3A17072696C6973222C226DC3A16A7573222C226AC3BA6E697573222C226AC3BA6C697573222C2261756775737A747573222C22737A657074656D626572222C226F6B74C3B3626572222C226E6F76656D626572222C22646563656D626572225D';
wwv_flow_api.g_varchar2_table(32) := '7D2C7765656B646179733A7B2273686F7274223A5B2276222C2268222C226B222C2273222C2263222C2270222C2273225D2C66756C6C3A5B22766173C3A1726E6170222C2268C3A97466C591222C226B656464222C22737A65726461222C226373C3BC74';
wwv_flow_api.g_varchar2_table(33) := 'C3B67274C3B66B222C2270C3A96E74656B222C22737A6F6D626174225D7D7D2C67723A7B6E616D653A22CE95CEBBCEBBCEB7CEBDCEB9CEBACEAC222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B22CE99CEB1CEBD222C22';
wwv_flow_api.g_varchar2_table(34) := 'CEA6CEB5CEB2222C22CE9CCEACCF81222C22CE91CF80CF81222C22CE9CCEACCEB9222C22CE99CEBFCF8DCEBD222C22CE99CEBFCF8DCEBB222C22CE91CF8DCEB3222C22CEA3CEB5CF80222C22CE9FCEBACF84222C22CE9DCEBFCEAD222C22CE94CEB5CEBA';
wwv_flow_api.g_varchar2_table(35) := '225D2C66756C6C3A5B22CE99CEB1CEBDCEBFCF85CEACCF81CEB9CEBFCF82222C22CEA6CEB5CEB2CF81CEBFCF85CEACCF81CEB9CEBFCF82222C22CE9CCEACCF81CF84CEB9CEBFCF82222C22CE91CF80CF81CEAFCEBBCEB9CEBFCF82222C22CE9CCEACCEB9';
wwv_flow_api.g_varchar2_table(36) := 'CEBFCF82222C22CE99CEBFCF8DCEBDCEB9CEBFCF82222C22CE99CEBFCF8DCEBBCEB9CEBFCF82222C22CE91CF8DCEB3CEBFCF85CF83CF84CEBFCF82222C22CEA3CEB5CF80CF84CEADCEBCCEB2CF81CEB9CEBFCF82222C22CE9FCEBACF84CF8ECEB2CF81CE';
wwv_flow_api.g_varchar2_table(37) := 'B9CEBFCF82222C22CE9DCEBFCEADCEBCCEB2CF81CEB9CEBFCF82222C22CE94CEB5CEBACEADCEBCCEB2CF81CEB9CEBFCF82225D7D2C7765656B646179733A7B2273686F7274223A5B22CE9A222C22CE94222C22CEA4222C22CEA4222C22CEA0222C22CEA0';
wwv_flow_api.g_varchar2_table(38) := '222C22CEA3225D2C66756C6C3A5B22CE9ACF85CF81CEB9CEB1CEBACEAE222C22CE94CEB5CF85CF84CEADCF81CEB1222C22CEA4CF81CEAFCF84CEB7222C22CEA4CEB5CF84CEACCF81CF84CEB7222C22CEA0CEADCEBCCF80CF84CEB7222C22CEA0CEB1CF81';
wwv_flow_api.g_varchar2_table(39) := 'CEB1CF83CEBACEB5CF85CEAE222C22CEA3CEACCEB2CEB2CEB1CF84CEBF225D7D7D2C65733A7B6E616D653A2245737061C3B16F6C222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B22456E65222C22466562222C224D6172';
wwv_flow_api.g_varchar2_table(40) := '222C22416272222C224D6179222C224A756E222C224A756C222C2241676F222C22536570222C224F6374222C224E6F76222C22446963225D2C66756C6C3A5B22456E65726F222C224665627265726F222C224D61727A6F222C22416272696C222C224D61';
wwv_flow_api.g_varchar2_table(41) := '796F222C224A756E696F222C224A756C696F222C2241676F73746F222C225365707469656D627265222C224F637475627265222C224E6F7669656D627265222C2244696369656D627265225D7D2C7765656B646179733A7B2273686F7274223A5B224422';
wwv_flow_api.g_varchar2_table(42) := '2C224C222C224D222C2258222C224A222C2256222C2253225D2C66756C6C3A5B22446F6D696E676F222C224C756E6573222C224D6172746573222C224D69C3A972636F6C6573222C224A7565766573222C22566965726E6573222C2253C3A16261646F22';
wwv_flow_api.g_varchar2_table(43) := '5D7D7D2C64613A7B6E616D653A2244616E736B222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B226A616E222C22666562222C226D6172222C22617072222C226D616A222C226A756E222C226A756C222C22617567222C22';
wwv_flow_api.g_varchar2_table(44) := '736570222C226F6B74222C226E6F76222C22646563225D2C66756C6C3A5B226A616E756172222C2266656272756172222C226D61727473222C22617072696C222C226D616A222C226A756E69222C226A756C69222C22617567757374222C227365707465';
wwv_flow_api.g_varchar2_table(45) := '6D626572222C226F6B746F626572222C226E6F76656D626572222C22646563656D626572225D7D2C7765656B646179733A7B2273686F7274223A5B2273222C226D222C2274222C226F222C2274222C2266222C226C225D2C66756C6C3A5B2273C3B86E64';
wwv_flow_api.g_varchar2_table(46) := '6167222C226D616E646167222C2274697273646167222C226F6E73646167222C22746F7273646167222C22667265646167222C226CC3B872646167225D7D7D2C64653A7B6E616D653A2244657574736368222C677265676F7269616E3A21302C6D6F6E74';
wwv_flow_api.g_varchar2_table(47) := '68733A7B2273686F7274223A5B224A616E222C22466562222C224DC3A472222C22417072222C224D6169222C224A756E222C224A756C222C22417567222C22536570222C224F6B74222C224E6F76222C2244657A225D2C66756C6C3A5B224A616E756172';
wwv_flow_api.g_varchar2_table(48) := '222C2246656272756172222C224DC3A4727A222C22417072696C222C224D6169222C224A756E69222C224A756C69222C22417567757374222C2253657074656D626572222C224F6B746F626572222C224E6F76656D626572222C2244657A656D62657222';
wwv_flow_api.g_varchar2_table(49) := '5D7D2C7765656B646179733A7B2273686F7274223A5B2253222C224D222C2244222C224D222C2244222C2246222C2253225D2C66756C6C3A5B22536F6E6E746167222C224D6F6E746167222C224469656E73746167222C224D697474776F6368222C2244';
wwv_flow_api.g_varchar2_table(50) := '6F6E6E657273746167222C2246726569746167222C2253616D73746167225D7D7D2C6E6C3A7B6E616D653A224E656465726C616E6473222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B226A616E222C22666562222C226D';
wwv_flow_api.g_varchar2_table(51) := '6161222C22617072222C226D6569222C226A756E222C226A756C222C22617567222C22736570222C226F6B74222C226E6F76222C22646563225D2C66756C6C3A5B226A616E75617269222C226665627275617269222C226D61617274222C22617072696C';
wwv_flow_api.g_varchar2_table(52) := '222C226D6569222C226A756E69222C226A756C69222C226175677573747573222C2273657074656D626572222C226F6B746F626572222C226E6F76656D626572222C22646563656D626572225D7D2C7765656B646179733A7B2273686F7274223A5B227A';
wwv_flow_api.g_varchar2_table(53) := '222C226D222C2264222C2277222C2264222C2276222C227A225D2C66756C6C3A5B227A6F6E646167222C226D61616E646167222C2264696E73646167222C22776F656E73646167222C22646F6E646572646167222C227672696A646167222C227A617465';
wwv_flow_api.g_varchar2_table(54) := '72646167225D7D7D2C706C3A7B6E616D653A226AC4997A796B20706F6C736B69222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B22737479222C226C7574222C226D6172222C226B7769222C226D616A222C22637A65222C';
wwv_flow_api.g_varchar2_table(55) := '226C6970222C22736965222C2277727A222C227061C5BA222C226C6973222C22677275225D2C66756C6C3A5B22737479637A65C584222C226C757479222C226D61727A6563222C226B776965636965C584222C226D616A222C22637A657277696563222C';
wwv_flow_api.g_varchar2_table(56) := '226C6970696563222C2273696572706965C584222C2277727A65736965C584222C227061C5BA647A6965726E696B222C226C6973746F706164222C22677275647A6965C584225D7D2C7765656B646179733A7B2273686F7274223A5B226E222C2270222C';
wwv_flow_api.g_varchar2_table(57) := '2277222C22C59B222C2263222C2270222C2273225D2C66756C6C3A5B226E6965647A69656C61222C22706F6E6965647A6961C582656B222C2277746F72656B222C22C59B726F6461222C22637A77617274656B222C227069C48574656B222C22736F626F';
wwv_flow_api.g_varchar2_table(58) := '7461225D7D7D2C70743A7B6E616D653A22506F7274756775C3AA73222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B224A616E6569726F222C2246657665726569726F222C224D6172C3A76F222C22416272696C222C224D';
wwv_flow_api.g_varchar2_table(59) := '61696F222C224A756E686F222C224A756C686F222C2241676F73746F222C22536574656D62726F222C224F75747562726F222C224E6F76656D62726F222C2244657A656D62726F225D2C66756C6C3A5B224A616E6569726F222C2246657665726569726F';
wwv_flow_api.g_varchar2_table(60) := '222C224D6172C3A76F222C22416272696C222C224D61696F222C224A756E686F222C224A756C686F222C2241676F73746F222C22536574656D62726F222C224F75747562726F222C224E6F76656D62726F222C2244657A656D62726F225D7D2C7765656B';
wwv_flow_api.g_varchar2_table(61) := '646179733A7B2273686F7274223A5B2244222C2253222C2254222C2251222C2251222C2253222C2253225D2C66756C6C3A5B22446F6D696E676F222C22536567756E6461222C22546572C3A761222C22517561727461222C225175696E7461222C225365';
wwv_flow_api.g_varchar2_table(62) := '787461222C2253C3A16261646F225D7D7D2C73693A7B6E616D653A22536C6F76656EC5A1C48D696E61222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B226A616E222C22666562222C226D6172222C22617072222C226D61';
wwv_flow_api.g_varchar2_table(63) := '6A222C226A756E222C226A756C222C22617667222C22736570222C226F6B74222C226E6F76222C22646563225D2C66756C6C3A5B226A616E756172222C2266656272756172222C226D61726563222C22617072696C222C226D616A222C226A756E696A22';
wwv_flow_api.g_varchar2_table(64) := '2C226A756C696A222C22617667757374222C2273657074656D626572222C226F6B746F626572222C226E6F76656D626572222C22646563656D626572225D7D2C7765656B646179733A7B2273686F7274223A5B226E222C2270222C2274222C2273222C22';
wwv_flow_api.g_varchar2_table(65) := 'C48D222C2270222C2273225D2C66756C6C3A5B226E6564656C6A61222C22706F6E6564656C6A656B222C22746F72656B222C227372656461222C22C48D65747274656B222C22706574656B222C22736F626F7461225D7D7D2C756B3A7B6E616D653A22D1';
wwv_flow_api.g_varchar2_table(66) := '83D0BAD180D0B0D197D0BDD181D18CD0BAD0B020D0BCD0BED0B2D0B0222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B22D181D196D187D0B5D0BDD18C222C22D0BBD18ED182D0B8D0B9222C22D0B1D0B5D180D0B5D0B7D0';
wwv_flow_api.g_varchar2_table(67) := 'B5D0BDD18C222C22D0BAD0B2D196D182D0B5D0BDD18C222C22D182D180D0B0D0B2D0B5D0BDD18C222C22D187D0B5D180D0B2D0B5D0BDD18C222C22D0BBD0B8D0BFD0B5D0BDD18C222C22D181D0B5D180D0BFD0B5D0BDD18C222C22D0B2D0B5D180D0B5D1';
wwv_flow_api.g_varchar2_table(68) := '81D0B5D0BDD18C222C22D0B6D0BED0B2D182D0B5D0BDD18C222C22D0BBD0B8D181D182D0BED0BFD0B0D0B4222C22D0B3D180D183D0B4D0B5D0BDD18C225D2C66756C6C3A5B22D181D196D187D0B5D0BDD18C222C22D0BBD18ED182D0B8D0B9222C22D0B1';
wwv_flow_api.g_varchar2_table(69) := 'D0B5D180D0B5D0B7D0B5D0BDD18C222C22D0BAD0B2D196D182D0B5D0BDD18C222C22D182D180D0B0D0B2D0B5D0BDD18C222C22D187D0B5D180D0B2D0B5D0BDD18C222C22D0BBD0B8D0BFD0B5D0BDD18C222C22D181D0B5D180D0BFD0B5D0BDD18C222C22';
wwv_flow_api.g_varchar2_table(70) := 'D0B2D0B5D180D0B5D181D0B5D0BDD18C222C22D0B6D0BED0B2D182D0B5D0BDD18C222C22D0BBD0B8D181D182D0BED0BFD0B0D0B4222C22D0B3D180D183D0B4D0B5D0BDD18C225D7D2C7765656B646179733A7B2273686F7274223A5B22D0BD222C22D0BF';
wwv_flow_api.g_varchar2_table(71) := '222C22D0B2222C22D181222C22D187222C22D0BF222C22D181225D2C66756C6C3A5B22D0BDD0B5D0B4D196D0BBD18F222C22D0BFD0BED0BDD0B5D0B4D196D0BBD0BED0BA222C22D0B2D196D0B2D182D0BED180D0BED0BA222C22D181D0B5D180D0B5D0B4';
wwv_flow_api.g_varchar2_table(72) := 'D0B0222C22D187D0B5D182D0B2D0B5D180222C22D0BF27D18FD182D0BDD0B8D186D18F222C22D181D183D0B1D0BED182D0B0225D7D7D2C72753A7B6E616D653A22D180D183D181D181D0BAD0B8D0B920D18FD0B7D18BD0BA222C677265676F7269616E3A';
wwv_flow_api.g_varchar2_table(73) := '21302C6D6F6E7468733A7B2273686F7274223A5B22D18FD0BDD0B2D0B0D180D18C222C22D184D0B5D0B2D180D0B0D0BBD18C222C22D0BCD0B0D180D182222C22D0B0D0BFD180D0B5D0BBD18C222C22D0BCD0B0D0B9222C22D0B8D18ED0BDD18C222C22D0';
wwv_flow_api.g_varchar2_table(74) := 'B8D18ED0BBD18C222C22D0B0D0B2D0B3D183D181D182222C22D181D0B5D0BDD182D18FD0B1D180D18C222C22D0BED0BAD182D18FD0B1D180D18C222C22D0BDD0BED18FD0B1D180D18C222C22D0B4D0B5D0BAD0B0D0B1D180D18C225D2C66756C6C3A5B22';
wwv_flow_api.g_varchar2_table(75) := 'D18FD0BDD0B2D0B0D180D18C222C22D184D0B5D0B2D180D0B0D0BBD18C222C22D0BCD0B0D180D182222C22D0B0D0BFD180D0B5D0BBD18C222C22D0BCD0B0D0B9222C22D0B8D18ED0BDD18C222C22D0B8D18ED0BBD18C222C22D0B0D0B2D0B3D183D181D1';
wwv_flow_api.g_varchar2_table(76) := '82222C22D181D0B5D0BDD182D18FD0B1D180D18C222C22D0BED0BAD182D18FD0B1D180D18C222C22D0BDD0BED18FD0B1D180D18C222C22D0B4D0B5D0BAD0B0D0B1D180D18C225D7D2C7765656B646179733A7B2273686F7274223A5B22D0B2222C22D0BF';
wwv_flow_api.g_varchar2_table(77) := '222C22D0B2222C22D181222C22D187222C22D0BF222C22D181225D2C66756C6C3A5B22D0B2D0BED181D0BAD180D0B5D181D0B5D0BDD18CD0B5222C22D0BFD0BED0BDD0B5D0B4D0B5D0BBD18CD0BDD0B8D0BA222C22D0B2D182D0BED180D0BDD0B8D0BA22';
wwv_flow_api.g_varchar2_table(78) := '2C22D181D180D0B5D0B4D0B0222C22D187D0B5D182D0B2D0B5D180D0B3222C22D0BFD18FD182D0BDD0B8D186D0B0222C22D181D183D0B1D0B1D0BED182D0B0225D7D7D2C74723A7B6E616D653A2254C3BC726BC3A765222C677265676F7269616E3A2130';
wwv_flow_api.g_varchar2_table(79) := '2C6D6F6E7468733A7B2273686F7274223A5B224F6361222C22C59E7562222C224D6172222C224E6973222C224D6179222C2248617A222C2254656D222C2241C49F75222C2245796C222C22456B69222C224B6173222C22417261225D2C66756C6C3A5B22';
wwv_flow_api.g_varchar2_table(80) := '4F63616B222C22C59E75626174222C224D617274222C224E6973616E222C224D6179C4B173222C2248617A6972616E222C2254656D6D757A222C2241C49F7573746F73222C2245796CC3BC6C222C22456B696D222C224B6173C4B16D222C224172616CC4';
wwv_flow_api.g_varchar2_table(81) := 'B16B225D7D2C7765656B646179733A7B2273686F7274223A5B2250222C2250222C2253222C22C387222C2250222C2243222C2243225D2C66756C6C3A5B2250617A6172222C2250617A617274657369222C2253616C69222C22C3876172C59F616D626122';
wwv_flow_api.g_varchar2_table(82) := '2C22506572C59F656D6265222C2243756D61222C2243756D617274657369225D7D7D2C6B6F3A7B6E616D653A22ECA1B0EC84A0EBA790222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B2231EC9B94222C2232EC9B94222C';
wwv_flow_api.g_varchar2_table(83) := '2233EC9B94222C2234EC9B94222C2235EC9B94222C2236EC9B94222C2237EC9B94222C2238EC9B94222C2239EC9B94222C223130EC9B94222C223131EC9B94222C223132EC9B94225D2C66756C6C3A5B2231EC9B94222C2232EC9B94222C2233EC9B9422';
wwv_flow_api.g_varchar2_table(84) := '2C2234EC9B94222C2235EC9B94222C2236EC9B94222C2237EC9B94222C2238EC9B94222C2239EC9B94222C223130EC9B94222C223131EC9B94222C223132EC9B94225D7D2C7765656B646179733A7B2273686F7274223A5B22EC9DBC222C22EC9B94222C';
wwv_flow_api.g_varchar2_table(85) := '22ED9994222C22EC8898222C22EBAAA9222C22EAB888222C22ED86A0225D2C66756C6C3A5B22EC9DBCEC9A94EC9DBC222C22EC9B94EC9A94EC9DBC222C22ED9994EC9A94EC9DBC222C22EC8898EC9A94EC9DBC222C22EBAAA9EC9A94EC9DBC222C22EAB8';
wwv_flow_api.g_varchar2_table(86) := '88EC9A94EC9DBC222C22ED86A0EC9A94EC9DBC225D7D7D2C66693A7B6E616D653A2273756F6D656E206B69656C69222C677265676F7269616E3A21302C6D6F6E7468733A7B2273686F7274223A5B2254616D222C2248656C222C224D6161222C22487568';
wwv_flow_api.g_varchar2_table(87) := '222C22546F75222C224B6573222C22486569222C22456C6F222C22537979222C224C6F6B222C224D6172222C224A6F75225D2C66756C6C3A5B2254616D6D696B7575222C2248656C6D696B7575222C224D61616C69736B7575222C2248756874696B7575';
wwv_flow_api.g_varchar2_table(88) := '222C22546F756B6F6B7575222C224B6573C3A46B7575222C224865696EC3A46B7575222C22456C6F6B7575222C22537979736B7575222C224C6F6B616B7575222C224D61727261736B7575222C224A6F756C756B7575225D7D2C7765656B646179733A7B';
wwv_flow_api.g_varchar2_table(89) := '2273686F7274223A5B2253222C224D222C2254222C224B222C2254222C2250222C224C225D2C66756C6C3A5B2253756E6E756E746169222C224D61616E616E746169222C2254696973746169222C224B65736B697669696B6B6F222C22546F7273746169';
wwv_flow_api.g_varchar2_table(90) := '222C225065726A616E746169222C224C6175616E746169225D7D7D2C76693A7B6E616D653A225469E1BABF6E67207669E1BB8774222C677265676F7269616E3A21312C6D6F6E7468733A7B2273686F7274223A5B2254682E3031222C2254682E3032222C';
wwv_flow_api.g_varchar2_table(91) := '2254682E3033222C2254682E3034222C2254682E3035222C2254682E3036222C2254682E3037222C2254682E3038222C2254682E3039222C2254682E3130222C2254682E3131222C2254682E3132225D2C66756C6C3A5B225468C3A16E67203031222C22';
wwv_flow_api.g_varchar2_table(92) := '5468C3A16E67203032222C225468C3A16E67203033222C225468C3A16E67203034222C225468C3A16E67203035222C225468C3A16E67203036222C225468C3A16E67203037222C225468C3A16E67203038222C225468C3A16E67203039222C225468C3A1';
wwv_flow_api.g_varchar2_table(93) := '6E67203130222C225468C3A16E67203131222C225468C3A16E67203132225D7D2C7765656B646179733A7B2273686F7274223A5B22434E222C225432222C225433222C225434222C225435222C225436222C225437225D2C66756C6C3A5B224368E1BBA7';
wwv_flow_api.g_varchar2_table(94) := '206E68E1BAAD74222C225468E1BBA920686169222C225468E1BBA9206261222C225468E1BBA92074C6B0222C225468E1BBA9206EC4836D222C225468E1BBA92073C3A175222C225468E1BBA92062E1BAA379225D7D7D7D2C6E3D7B7D2C723D6E756C6C2C';
wwv_flow_api.g_varchar2_table(95) := '6C3D21312C733D6E756C6C2C643D6E756C6C2C753D6E756C6C2C633D21312C6B3D66756E6374696F6E28297B72657475726E2F416E64726F69647C7765624F537C6950686F6E657C695061647C69506F647C426C61636B42657272797C49454D6F62696C';
wwv_flow_api.g_varchar2_table(96) := '657C4F70657261204D696E692F692E74657374286E6176696761746F722E757365724167656E74293F21303A21317D2C703D66756E6374696F6E28297B7226266E5B722E69645D2E66782626216E5B722E69645D2E66786D6F62696C6526262865287769';
wwv_flow_api.g_varchar2_table(97) := '6E646F77292E776964746828293C3438303F722E656C656D656E742E72656D6F7665436C61737328227069636B65722D66787322293A722E656C656D656E742E616464436C61737328227069636B65722D6678732229297D2C6D3D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(98) := '297B72657475726E206E5B722E69645D2E6A756D703E3D6E5B722E69645D2E6B65792E792E6D61782D6E5B722E69645D2E6B65792E792E6D696E3F21313A21307D2C673D66756E6374696F6E28297B76617220653D4128772829292C613D412876282929';
wwv_flow_api.g_varchar2_table(99) := '3B6966286E5B722E69645D2E6C6F636B297B6966282266726F6D223D3D6E5B722E69645D2E6C6F636B2972657475726E20613E653F285128292C722E656C656D656E742E616464436C61737328227069636B65722D6C6B6422292C2130293A28722E656C';
wwv_flow_api.g_varchar2_table(100) := '656D656E742E72656D6F7665436C61737328227069636B65722D6C6B6422292C2131293B69662822746F223D3D6E5B722E69645D2E6C6F636B2972657475726E20653E613F285128292C722E656C656D656E742E616464436C61737328227069636B6572';
wwv_flow_api.g_varchar2_table(101) := '2D6C6B6422292C2130293A28722E656C656D656E742E72656D6F7665436C61737328227069636B65722D6C6B6422292C2131297D72657475726E206E5B722E69645D2E64697361626C65646179733F2D31213D6E5B722E69645D2E64697361626C656461';
wwv_flow_api.g_varchar2_table(102) := '79732E696E6465784F662865293F285128292C722E656C656D656E742E616464436C61737328227069636B65722D6C6B6422292C2130293A28722E656C656D656E742E72656D6F7665436C61737328227069636B65722D6C6B6422292C2131293A766F69';
wwv_flow_api.g_varchar2_table(103) := '6420307D2C683D66756E6374696F6E2865297B72657475726E206525313D3D3D307D2C663D66756E6374696F6E2865297B76617220613D2F285E5C647B312C347D5B5C2E7C5C5C2F7C2D5D5C647B312C327D5B5C2E7C5C5C2F7C2D5D5C647B312C347D29';
wwv_flow_api.g_varchar2_table(104) := '285C732A283F3A303F5B312D395D3A5B302D355D7C31283F3D5B3031325D295C643A5B302D355D295C645C732A5B61705D6D293F242F3B72657475726E20612E746573742865297D2C793D66756E6374696F6E2865297B72657475726E20706172736549';
wwv_flow_api.g_varchar2_table(105) := '6E74286E5B722E69645D2E6B65795B655D2E63757272656E74297D2C623D66756E6374696F6E2865297B72657475726E207061727365496E74286E5B722E69645D2E6B65795B655D2E746F646179297D2C763D66756E6374696F6E28297B72657475726E';
wwv_flow_api.g_varchar2_table(106) := '206228226D22292B222F222B6228226422292B222F222B6228227922297D2C773D66756E6374696F6E28297B72657475726E207928226D22292B222F222B7928226422292B222F222B7928227922297D2C543D66756E6374696F6E28652C61297B666F72';
wwv_flow_api.g_varchar2_table(107) := '2876617220693D5B5D2C743D6E5B722E69645D2E6B65795B655D2C6C3D742E6D696E3B6C3C3D742E6D61783B6C2B2B296C25613D3D302626692E70757368286C293B72657475726E20697D2C4D3D66756E6374696F6E28652C61297B666F722876617220';
wwv_flow_api.g_varchar2_table(108) := '693D615B305D2C743D4D6174682E61627328652D69292C6E3D303B6E3C612E6C656E6774683B6E2B2B297B76617220723D4D6174682E61627328652D615B6E5D293B743E72262628743D722C693D615B6E5D297D72657475726E20697D2C433D66756E63';
wwv_flow_api.g_varchar2_table(109) := '74696F6E28652C61297B76617220693D6E5B722E69645D2E6B65795B655D3B72657475726E20613E692E6D61783F4328652C612D692E6D61782B28692E6D696E2D3129293A613C692E6D696E3F4328652C612B312B28692E6D61782D692E6D696E29293A';
wwv_flow_api.g_varchar2_table(110) := '617D2C6A3D66756E6374696F6E28297B72657475726E20745B6E5B722E69645D2E6C616E675D2E677265676F7269616E3F5B312C322C332C342C352C362C305D3A5B302C312C322C332C342C352C365D7D2C443D66756E6374696F6E2865297B72657475';
wwv_flow_api.g_varchar2_table(111) := '726E207A2827756C2E7069636B5B646174612D6B3D22272B652B27225D27297D2C533D66756E6374696F6E28612C69297B756C3D442861293B76617220743D5B5D3B72657475726E20756C2E66696E6428226C6922292E656163682866756E6374696F6E';
wwv_flow_api.g_varchar2_table(112) := '28297B742E7075736828652874686973292E61747472282276616C75652229297D292C226C617374223D3D693F745B742E6C656E6774682D315D3A745B305D7D2C7A3D66756E6374696F6E2865297B72657475726E20723F722E656C656D656E742E6669';
wwv_flow_api.g_varchar2_table(113) := '6E642865293A766F696420307D2C413D66756E6374696F6E2865297B72657475726E20446174652E70617273652865292F3165337D2C783D66756E6374696F6E28297B6E5B722E69645D2E6C61726765262628722E656C656D656E742E746F67676C6543';
wwv_flow_api.g_varchar2_table(114) := '6C61737328227069636B65722D6C6722292C592829297D2C4A3D66756E6374696F6E28297B7A2822756C2E7069636B2E7069636B2D6C22292E746F67676C65436C617373282276697369626C6522297D2C463D66756E6374696F6E28297B69662821722E';
wwv_flow_api.g_varchar2_table(115) := '656C656D656E742E686173436C61737328227069636B65722D6D6F64616C2229297B76617220653D722E696E7075742C613D652E6F666673657428292E6C6566742B652E6F75746572576964746828292F322C693D652E6F666673657428292E746F702B';
wwv_flow_api.g_varchar2_table(116) := '652E6F7574657248656967687428293B722E656C656D656E742E637373287B6C6566743A612C746F703A697D297D7D2C4F3D66756E6374696F6E2865297B6E5B722E69645D2E6C616E673D4F626A6563742E6B6579732874295B655D2C4528292C472829';
wwv_flow_api.g_varchar2_table(117) := '7D2C453D66756E6374696F6E28297B76617220613D6A28293B7A28222E7069636B2D6C67202E7069636B2D6C672D68206C6922292E656163682866756E6374696F6E2869297B652874686973292E68746D6C28745B6E5B722E69645D2E6C616E675D2E77';
wwv_flow_api.g_varchar2_table(118) := '65656B646179732E73686F72745B615B695D5D297D292C7A2822756C2E7069636B2E7069636B2D6D206C6922292E656163682866756E6374696F6E28297B652874686973292E68746D6C28745B6E5B722E69645D2E6C616E675D2E6D6F6E7468732E7368';
wwv_flow_api.g_varchar2_table(119) := '6F72745B652874686973292E61747472282276616C756522292D315D297D297D2C4E3D66756E6374696F6E28297B722E656C656D656E742E616464436C61737328227069636B65722D666F63757322297D2C4C3D66756E6374696F6E28297B6728297C7C';
wwv_flow_api.g_varchar2_table(120) := '28722E656C656D656E742E72656D6F7665436C61737328227069636B65722D666F63757322292C722E656C656D656E742E686173436C61737328227069636B65722D6D6F64616C222926266528222E7069636B65722D6D6F64616C2D6F7665726C617922';
wwv_flow_api.g_varchar2_table(121) := '292E616464436C6173732822746F6869646522292C723D6E756C6C292C6C3D21317D2C503D66756E6374696F6E2861297B766172206C3D442861292C6F3D6E5B722E69645D2E6B65795B615D3B666F72286E5B722E69645D2E6B65795B615D2E63757272';
wwv_flow_api.g_varchar2_table(122) := '656E743D6F2E746F6461793C6F2E6D696E26266F2E6D696E7C7C6F2E746F6461792C693D6F2E6D696E3B693C3D6F2E6D61783B692B2B297B76617220733D693B226D223D3D61262628733D745B6E5B722E69645D2E6C616E675D2E6D6F6E7468732E7368';
wwv_flow_api.g_varchar2_table(123) := '6F72745B692D315D292C226C223D3D61262628733D745B4F626A6563742E6B6579732874295B695D5D2E6E616D65292C732B3D2264223D3D613F223C7370616E3E3C2F7370616E3E223A22222C6528223C6C693E222C7B76616C75653A692C68746D6C3A';
wwv_flow_api.g_varchar2_table(124) := '737D292E617070656E64546F286C297D6528223C6469763E222C7B22636C617373223A227069636B2D617277207069636B2D6172772D7331207069636B2D6172772D6C222C68746D6C3A6528223C693E222C7B22636C617373223A227069636B2D692D6C';
wwv_flow_api.g_varchar2_table(125) := '227D297D292E617070656E64546F286C292C6528223C6469763E222C7B22636C617373223A227069636B2D617277207069636B2D6172772D7331207069636B2D6172772D72222C68746D6C3A6528223C693E222C7B22636C617373223A227069636B2D69';
wwv_flow_api.g_varchar2_table(126) := '2D72227D297D292E617070656E64546F286C292C2279223D3D612626286528223C6469763E222C7B22636C617373223A227069636B2D617277207069636B2D6172772D7332207069636B2D6172772D6C222C68746D6C3A6528223C693E222C7B22636C61';
wwv_flow_api.g_varchar2_table(127) := '7373223A227069636B2D692D6C227D297D292E617070656E64546F286C292C6528223C6469763E222C7B22636C617373223A227069636B2D617277207069636B2D6172772D7332207069636B2D6172772D72222C68746D6C3A6528223C693E222C7B2263';
wwv_flow_api.g_varchar2_table(128) := '6C617373223A227069636B2D692D72227D297D292E617070656E64546F286C29292C4B28612C79286129297D2C593D66756E6374696F6E28297B76617220613D302C693D7A28222E7069636B2D6C672D6222293B692E66696E6428226C6922292E656D70';
wwv_flow_api.g_varchar2_table(129) := '747928292E72656D6F7665436C61737328227069636B2D6E207069636B2D62207069636B2D61207069636B2D76207069636B2D6C6B207069636B2D736C207069636B2D6822292E617474722822646174612D76616C7565222C2222293B766172206C3D28';
wwv_flow_api.g_varchar2_table(130) := '6E6577204461746528772829292C6E657720446174652877282929292C6F3D6E6577204461746528772829292C733D66756E6374696F6E2865297B76617220613D652E6765744D6F6E746828292C693D652E67657446756C6C5965617228292C743D6925';
wwv_flow_api.g_varchar2_table(131) := '343D3D302626286925313030213D307C7C69253430303D3D30293B72657475726E5B33312C743F32393A32382C33312C33302C33312C33302C33312C33312C33302C33312C33302C33315D5B615D7D3B6F2E7365744D6F6E7468286F2E6765744D6F6E74';
wwv_flow_api.g_varchar2_table(132) := '6828292D31292C6C2E736574446174652831293B76617220643D6C2E67657444617928292D313B303E64262628643D36292C745B6E5B722E69645D2E6C616E675D2E677265676F7269616E262628642D2D2C303E64262628643D3629293B666F72287661';
wwv_flow_api.g_varchar2_table(133) := '7220753D73286F292D643B753C3D73286F293B752B2B29692E66696E6428226C6922292E65712861292E68746D6C2875292E616464436C61737328227069636B2D62207069636B2D6E207069636B2D6822292C612B2B3B666F722876617220753D313B75';
wwv_flow_api.g_varchar2_table(134) := '3C3D73286C293B752B2B29692E66696E6428226C6922292E65712861292E68746D6C2875292E616464436C61737328227069636B2D6E207069636B2D7622292E617474722822646174612D76616C7565222C75292C612B2B3B696628692E66696E642822';
wwv_flow_api.g_varchar2_table(135) := '6C692E7069636B2D6E22292E6C656E6774683C343229666F722876617220633D34322D692E66696E6428226C692E7069636B2D6E22292E6C656E6774682C753D313B633E3D753B752B2B29692E66696E6428226C6922292E65712861292E68746D6C2875';
wwv_flow_api.g_varchar2_table(136) := '292E616464436C61737328227069636B2D61207069636B2D6E207069636B2D6822292C612B2B3B6E5B722E69645D2E6C6F636B2626282266726F6D223D3D3D6E5B722E69645D2E6C6F636B3F7928227922293C3D6228227922292626287928226D22293D';
wwv_flow_api.g_varchar2_table(137) := '3D6228226D22293F7A28272E7069636B2D6C67202E7069636B2D6C672D62206C692E7069636B2D765B646174612D76616C75653D22272B6228226422292B27225D27292E70726576416C6C28226C6922292E616464436C61737328227069636B2D6C6B22';
wwv_flow_api.g_varchar2_table(138) := '293A7928226D22293C6228226D22293F7A28222E7069636B2D6C67202E7069636B2D6C672D62206C6922292E616464436C61737328227069636B2D6C6B22293A7928226D22293E6228226D222926267928227922293C62282279222926267A28222E7069';
wwv_flow_api.g_varchar2_table(139) := '636B2D6C67202E7069636B2D6C672D62206C6922292E616464436C61737328227069636B2D6C6B2229293A7928227922293E3D6228227922292626287928226D22293D3D6228226D22293F7A28272E7069636B2D6C67202E7069636B2D6C672D62206C69';
wwv_flow_api.g_varchar2_table(140) := '2E7069636B2D765B646174612D76616C75653D22272B6228226422292B27225D27292E6E657874416C6C28226C6922292E616464436C61737328227069636B2D6C6B22293A7928226D22293E6228226D22293F7A28222E7069636B2D6C67202E7069636B';
wwv_flow_api.g_varchar2_table(141) := '2D6C672D62206C6922292E616464436C61737328227069636B2D6C6B22293A7928226D22293C6228226D222926267928227922293E62282279222926267A28222E7069636B2D6C67202E7069636B2D6C672D62206C6922292E616464436C617373282270';
wwv_flow_api.g_varchar2_table(142) := '69636B2D6C6B222929292C6E5B722E69645D2E64697361626C65646179732626652E65616368286E5B722E69645D2E64697361626C65646179732C66756E6374696F6E28652C61297B69662861262666286129297B76617220693D6E6577204461746528';
wwv_flow_api.g_varchar2_table(143) := '3165332A61293B692E6765744D6F6E746828292B313D3D7928226D22292626692E67657446756C6C5965617228293D3D79282279222926267A28272E7069636B2D6C67202E7069636B2D6C672D62206C692E7069636B2D765B646174612D76616C75653D';
wwv_flow_api.g_varchar2_table(144) := '22272B692E6765744461746528292B27225D27292E616464436C61737328227069636B2D6C6B22297D7D292C7A28222E7069636B2D6C672D62206C692E7069636B2D765B646174612D76616C75653D222B7928226422292B225D22292E616464436C6173';
wwv_flow_api.g_varchar2_table(145) := '7328227069636B2D736C22297D2C483D66756E6374696F6E28297B76617220613D7928226D22292C693D7928227922292C6C3D6925343D3D302626286925313030213D307C7C69253430303D3D30293B6E5B722E69645D2E6B65792E642E6D61783D5B33';
wwv_flow_api.g_varchar2_table(146) := '312C6C3F32393A32382C33312C33302C33312C33302C33312C33312C33302C33312C33302C33315D5B612D315D2C7928226422293E6E5B722E69645D2E6B65792E642E6D61782626286E5B722E69645D2E6B65792E642E63757272656E743D6E5B722E69';
wwv_flow_api.g_varchar2_table(147) := '645D2E6B65792E642E6D61782C4B282264222C79282264222929292C7A28222E7069636B2D64206C6922292E72656D6F7665436C61737328227069636B2D776B6522292E656163682866756E6374696F6E28297B766172206C3D6E657720446174652861';
wwv_flow_api.g_varchar2_table(148) := '2B222F222B652874686973292E61747472282276616C756522292B222F222B69292E67657444617928293B652874686973292E66696E6428227370616E22292E68746D6C28745B6E5B722E69645D2E6C616E675D2E7765656B646179732E66756C6C5B6C';
wwv_flow_api.g_varchar2_table(149) := '5D292C28303D3D6C7C7C363D3D6C292626652874686973292E616464436C61737328227069636B2D776B6522297D292C722E656C656D656E742E686173436C61737328227069636B65722D6C6722292626287A28222E7069636B2D6C672D62206C692229';
wwv_flow_api.g_varchar2_table(150) := '2E72656D6F7665436C61737328227069636B2D776B6522292C7A28222E7069636B2D6C672D62206C692E7069636B2D7622292E656163682866756E6374696F6E28297B76617220743D6E6577204461746528612B222F222B652874686973292E61747472';
wwv_flow_api.g_varchar2_table(151) := '2822646174612D76616C756522292B222F222B69292E67657444617928293B28303D3D747C7C363D3D74292626652874686973292E616464436C61737328227069636B2D776B6522297D29297D2C473D66756E6374696F6E28297B722E656C656D656E74';
wwv_flow_api.g_varchar2_table(152) := '2E686173436C61737328227069636B65722D6C67222926265928292C4828292C7128297D2C4B3D66756E6374696F6E28652C61297B76617220693D442865293B696628692E66696E6428226C6922292E72656D6F7665436C61737328227069636B2D736C';
wwv_flow_api.g_varchar2_table(153) := '207069636B2D626672207069636B2D61667222292C613D3D5328652C226C6173742229297B76617220743D692E66696E6428276C695B76616C75653D22272B5328652C22666972737422292B27225D27293B742E636C6F6E6528292E696E736572744166';
wwv_flow_api.g_varchar2_table(154) := '74657228692E66696E6428226C695B76616C75653D222B612B225D2229292C742E72656D6F766528297D696628613D3D5328652C2266697273742229297B76617220743D692E66696E6428276C695B76616C75653D22272B5328652C226C61737422292B';
wwv_flow_api.g_varchar2_table(155) := '27225D27293B742E636C6F6E6528292E696E736572744265666F726528692E66696E6428226C695B76616C75653D222B612B225D2229292C742E72656D6F766528297D692E66696E6428226C695B76616C75653D222B612B225D22292E616464436C6173';
wwv_flow_api.g_varchar2_table(156) := '7328227069636B2D736C22292C692E66696E6428226C692E7069636B2D736C22292E6E657874416C6C28226C6922292E616464436C61737328227069636B2D61667222292C692E66696E6428226C692E7069636B2D736C22292E70726576416C6C28226C';
wwv_flow_api.g_varchar2_table(157) := '6922292E616464436C61737328227069636B2D62667222297D2C563D66756E6374696F6E28652C61297B76617220693D6E5B722E69645D2E6B65795B655D3B613E692E6D61782626282264223D3D6526264928226D222C22726967687422292C226D223D';
wwv_flow_api.g_varchar2_table(158) := '3D65262649282279222C22726967687422292C613D692E6D696E292C613C692E6D696E2626282264223D3D6526264928226D222C226C65667422292C226D223D3D65262649282279222C226C65667422292C613D692E6D6178292C6E5B722E69645D2E6B';
wwv_flow_api.g_varchar2_table(159) := '65795B655D2E63757272656E743D612C4B28652C61297D2C493D66756E6374696F6E28652C61297B76617220693D792865293B227269676874223D3D613F692B2B3A692D2D2C5628652C69297D2C513D66756E6374696F6E28297B722E656C656D656E74';
wwv_flow_api.g_varchar2_table(160) := '2E616464436C61737328227069636B65722D726D626C22297D2C573D66756E6374696F6E2865297B72657475726E2031303E653F2230222B653A657D2C423D66756E6374696F6E2865297B76617220613D5B227468222C227374222C226E64222C227264';
wwv_flow_api.g_varchar2_table(161) := '225D2C693D65253130303B72657475726E20652B28615B28692D3230292531305D7C7C615B695D7C7C615B305D297D2C713D66756E6374696F6E28297B6966282167282926266C297B76617220653D7928226422292C613D7928226D22292C693D792822';
wwv_flow_api.g_varchar2_table(162) := '7922292C6F3D6E6577204461746528612B222F222B652B222F222B69292E67657444617928292C733D6E5B722E69645D2E666F726D61742E7265706C616365282F5C622864295C622F672C57286529292E7265706C616365282F5C62286D295C622F672C';
wwv_flow_api.g_varchar2_table(163) := '57286129292E7265706C616365282F5C622853295C622F672C42286529292E7265706C616365282F5C622859295C622F672C69292E7265706C616365282F5C622855295C622F672C412877282929292E7265706C616365282F5C622844295C622F672C74';
wwv_flow_api.g_varchar2_table(164) := '5B6E5B722E69645D2E6C616E675D2E7765656B646179732E73686F72745B6F5D292E7265706C616365282F5C62286C295C622F672C745B6E5B722E69645D2E6C616E675D2E7765656B646179732E66756C6C5B6F5D292E7265706C616365282F5C622846';
wwv_flow_api.g_varchar2_table(165) := '295C622F672C745B6E5B722E69645D2E6C616E675D2E6D6F6E7468732E66756C6C5B612D315D292E7265706C616365282F5C62284D295C622F672C745B6E5B722E69645D2E6C616E675D2E6D6F6E7468732E73686F72745B612D315D292E7265706C6163';
wwv_flow_api.g_varchar2_table(166) := '65282F5C62286E295C622F672C61292E7265706C616365282F5C62286A295C622F672C65293B722E696E7075742E76616C2873292E6368616E676528292C6C3D21317D7D3B6966286B28292976617220553D7B693A22746F7563687374617274222C6D3A';
wwv_flow_api.g_varchar2_table(167) := '22746F7563686D6F7665222C653A22746F756368656E64227D3B656C73652076617220553D7B693A226D6F757365646F776E222C6D3A226D6F7573656D6F7665222C653A226D6F7573657570227D3B76617220583D226469762E6461746564726F707065';
wwv_flow_api.g_varchar2_table(168) := '722E7069636B65722D666F637573223B6528646F63756D656E74292E6F6E2822636C69636B222C66756E6374696F6E2865297B72262628722E696E7075742E697328652E746172676574297C7C722E656C656D656E742E697328652E746172676574297C';
wwv_flow_api.g_varchar2_table(169) := '7C30213D3D722E656C656D656E742E68617328652E746172676574292E6C656E6774687C7C284C28292C733D6E756C6C29297D292E6F6E28612E612C582B222E7069636B65722D726D626C222C66756E6374696F6E28297B722E656C656D656E742E6861';
wwv_flow_api.g_varchar2_table(170) := '73436C61737328227069636B65722D726D626C22292626652874686973292E72656D6F7665436C61737328227069636B65722D726D626C22297D292E6F6E28612E742C222E7069636B65722D6D6F64616C2D6F7665726C6179222C66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(171) := '297B652874686973292E72656D6F766528297D292E6F6E28552E692C582B22202E7069636B2D6C67206C692E7069636B2D76222C66756E6374696F6E28297B7A28222E7069636B2D6C672D62206C6922292E72656D6F7665436C61737328227069636B2D';
wwv_flow_api.g_varchar2_table(172) := '736C22292C652874686973292E616464436C61737328227069636B2D736C22292C6E5B722E69645D2E6B65792E642E63757272656E743D652874686973292E617474722822646174612D76616C756522292C4B282264222C652874686973292E61747472';
wwv_flow_api.g_varchar2_table(173) := '2822646174612D76616C75652229292C6C3D21307D292E6F6E2822636C69636B222C582B22202E7069636B2D62746E2D737A222C66756E6374696F6E28297B7828297D292E6F6E2822636C69636B222C582B22202E7069636B2D62746E2D6C6E67222C66';
wwv_flow_api.g_varchar2_table(174) := '756E6374696F6E28297B4A28297D292E6F6E28552E692C582B22202E7069636B2D6172772E7069636B2D6172772D7332222C66756E6374696F6E2861297B612E70726576656E7444656661756C7428292C733D6E756C6C3B76617220692C743D28652874';
wwv_flow_api.g_varchar2_table(175) := '686973292E636C6F736573742822756C22292E6461746128226B22292C6E5B722E69645D2E6A756D70293B693D652874686973292E686173436C61737328227069636B2D6172772D7222293F7928227922292B743A7928227922292D743B766172206F3D';
wwv_flow_api.g_varchar2_table(176) := '54282279222C74293B693E6F5B6F2E6C656E6774682D315D262628693D6F5B305D292C693C6F5B305D262628693D6F5B6F2E6C656E6774682D315D292C6E5B722E69645D2E6B65792E792E63757272656E743D692C4B282279222C792822792229292C6C';
wwv_flow_api.g_varchar2_table(177) := '3D21307D292E6F6E28552E692C582B22202E7069636B2D6172772E7069636B2D6172772D7331222C66756E6374696F6E2861297B612E70726576656E7444656661756C7428292C733D6E756C6C3B76617220693D652874686973292E636C6F7365737428';
wwv_flow_api.g_varchar2_table(178) := '22756C22292E6461746128226B22293B652874686973292E686173436C61737328227069636B2D6172772D7222293F4928692C22726967687422293A4928692C226C65667422292C6C3D21307D292E6F6E28552E692C582B2220756C2E7069636B2E7069';
wwv_flow_api.g_varchar2_table(179) := '636B2D79206C69222C66756E6374696F6E28297B633D21307D292E6F6E28552E652C582B2220756C2E7069636B2E7069636B2D79206C69222C66756E6374696F6E28297B6966286326266D2829297B652874686973292E636C6F736573742822756C2229';
wwv_flow_api.g_varchar2_table(180) := '2E746F67676C65436C61737328227069636B2D6A756D7022293B76617220613D4D287928227922292C54282279222C6E5B722E69645D2E6A756D7029293B6E5B722E69645D2E6B65792E792E63757272656E743D612C4B282279222C792822792229292C';
wwv_flow_api.g_varchar2_table(181) := '633D21317D7D292E6F6E28552E692C582B2220756C2E7069636B2E7069636B2D64206C69222C66756E6374696F6E28297B633D21307D292E6F6E28552E652C582B2220756C2E7069636B2E7069636B2D64206C69222C66756E6374696F6E28297B632626';
wwv_flow_api.g_varchar2_table(182) := '287828292C633D2131297D292E6F6E28552E692C582B2220756C2E7069636B2E7069636B2D6C206C69222C66756E6374696F6E28297B633D21307D292E6F6E28552E652C582B2220756C2E7069636B2E7069636B2D6C206C69222C66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(183) := '297B632626284A28292C4F28652874686973292E76616C2829292C633D2131297D292E6F6E28552E692C582B2220756C2E7069636B222C66756E6374696F6E2861297B696628733D65287468697329297B76617220693D732E6461746128226B22293B64';
wwv_flow_api.g_varchar2_table(184) := '3D6B28293F612E6F726967696E616C4576656E742E746F75636865735B305D2E70616765593A612E70616765592C753D792869297D7D292E6F6E28552E6D2C66756E6374696F6E2865297B696628633D21312C73297B652E70726576656E744465666175';
wwv_flow_api.g_varchar2_table(185) := '6C7428293B76617220613D732E6461746128226B22293B6F3D6B28293F652E6F726967696E616C4576656E742E746F75636865735B305D2E70616765593A652E70616765592C6F3D642D6F2C6F3D4D6174682E726F756E64282E3032362A6F292C693D75';
wwv_flow_api.g_varchar2_table(186) := '2B6F3B76617220743D4328612C69293B74213D6E5B722E69645D2E6B65795B615D2E63757272656E7426265628612C74292C6C3D21307D7D292E6F6E28552E652C66756E6374696F6E28297B73262628733D6E756C6C2C643D6E756C6C2C753D6E756C6C';
wwv_flow_api.g_varchar2_table(187) := '292C7226264728297D292E6F6E28552E692C582B22202E7069636B2D7375626D6974222C66756E6374696F6E28297B4C28297D292C652877696E646F77292E726573697A652866756E6374696F6E28297B722626284628292C702829297D292C652E666E';
wwv_flow_api.g_varchar2_table(188) := '2E6461746544726F707065723D66756E6374696F6E28297B72657475726E20652874686973292E656163682866756E6374696F6E28297B696628652874686973292E69732822696E7075742229262621652874686973292E686173436C61737328227069';
wwv_flow_api.g_varchar2_table(189) := '636B65722D696E7075742229297B76617220613D652874686973292C693D226461746564726F707065722D222B4F626A6563742E6B657973286E292E6C656E6774683B612E617474722822646174612D6964222C69292E616464436C6173732822706963';
wwv_flow_api.g_varchar2_table(190) := '6B65722D696E70757422292E70726F70287B747970653A2274657874222C726561646F6E6C793A21307D293B766172206F3D612E64617461282264656661756C742D64617465222926266628612E64617461282264656661756C742D646174652229293F';
wwv_flow_api.g_varchar2_table(191) := '612E64617461282264656661756C742D6461746522293A6E756C6C2C733D612E64617461282264697361626C65642D6461797322293F612E64617461282264697361626C65642D6461797322292E73706C697428222C22293A6E756C6C2C643D612E6461';
wwv_flow_api.g_varchar2_table(192) := '74612822666F726D617422297C7C226D2F642F59222C753D612E646174612822667822293D3D3D21313F612E646174612822667822293A21302C633D612E646174612822667822293D3D3D21313F22223A227069636B65722D667873222C6B3D612E6461';
wwv_flow_api.g_varchar2_table(193) := '7461282266782D6D6F62696C6522293D3D3D21313F612E64617461282266782D6D6F62696C6522293A21302C703D612E646174612822696E69742D73657422293D3D3D21313F21313A21302C6D3D612E6461746128226C616E6722292626612E64617461';
wwv_flow_api.g_varchar2_table(194) := '28226C616E672229696E20743F612E6461746128226C616E6722293A22656E222C673D612E6461746128226C617267652D6D6F646522293D3D3D21303F21303A21312C793D612E6461746128226C617267652D64656661756C7422293D3D3D2130262667';
wwv_flow_api.g_varchar2_table(195) := '3D3D3D21303F227069636B65722D6C67223A22222C623D2266726F6D223D3D612E6461746128226C6F636B22297C7C22746F223D3D612E6461746128226C6F636B22293F612E6461746128226C6F636B22293A21312C763D612E6461746128226A756D70';
wwv_flow_api.g_varchar2_table(196) := '222926266828612E6461746128226A756D702229293F612E6461746128226A756D7022293A31302C773D612E6461746128226D61782D79656172222926266828612E6461746128226D61782D796561722229293F612E6461746128226D61782D79656172';
wwv_flow_api.g_varchar2_table(197) := '22293A286E65772044617465292E67657446756C6C5965617228292C543D612E6461746128226D696E2D79656172222926266828612E6461746128226D696E2D796561722229293F612E6461746128226D696E2D7965617222293A313937302C4D3D612E';
wwv_flow_api.g_varchar2_table(198) := '6461746128226D6F64616C22293D3D3D21303F227069636B65722D6D6F64616C223A22222C433D612E6461746128227468656D6522297C7C227072696D617279222C443D612E6461746128227472616E736C6174652D6D6F646522293D3D3D21303F2130';
wwv_flow_api.g_varchar2_table(199) := '3A21313B696628732626652E6561636828732C66756E6374696F6E28652C61297B61262666286129262628735B655D3D41286129297D292C6E5B695D3D7B64697361626C65646179733A732C666F726D61743A642C66783A752C66786D6F62696C653A6B';
wwv_flow_api.g_varchar2_table(200) := '2C6C616E673A6D2C6C617267653A672C6C6F636B3A622C6A756D703A762C6B65793A7B6D3A7B6D696E3A312C6D61783A31322C63757272656E743A312C746F6461793A286E65772044617465292E6765744D6F6E746828292B317D2C643A7B6D696E3A31';
wwv_flow_api.g_varchar2_table(201) := '2C6D61783A33312C63757272656E743A312C746F6461793A286E65772044617465292E6765744461746528297D2C793A7B6D696E3A542C6D61783A772C63757272656E743A542C746F6461793A286E65772044617465292E67657446756C6C5965617228';
wwv_flow_api.g_varchar2_table(202) := '297D2C6C3A7B6D696E3A302C6D61783A4F626A6563742E6B6579732874292E6C656E6774682D312C63757272656E743A302C746F6461793A307D7D2C7472616E736C6174653A447D2C6F297B76617220533D2F5C642B2F672C783D6F2C4A3D782E6D6174';
wwv_flow_api.g_varchar2_table(203) := '63682853293B652E65616368284A2C66756E6374696F6E28652C61297B4A5B655D3D7061727365496E742861297D292C6E5B695D2E6B65792E6D2E746F6461793D4A5B305D26264A5B305D3C3D31323F4A5B305D3A6E5B695D2E6B65792E6D2E746F6461';
wwv_flow_api.g_varchar2_table(204) := '792C6E5B695D2E6B65792E642E746F6461793D4A5B315D26264A5B315D3C3D33313F4A5B315D3A6E5B695D2E6B65792E642E746F6461792C6E5B695D2E6B65792E792E746F6461793D4A5B325D3F4A5B325D3A6E5B695D2E6B65792E792E746F6461792C';
wwv_flow_api.g_varchar2_table(205) := '6E5B695D2E6B65792E792E746F6461793E6E5B695D2E6B65792E792E6D61782626286E5B695D2E6B65792E792E6D61783D6E5B695D2E6B65792E792E746F646179292C6E5B695D2E6B65792E792E746F6461793C6E5B695D2E6B65792E792E6D696E2626';
wwv_flow_api.g_varchar2_table(206) := '286E5B695D2E6B65792E792E6D696E3D6E5B695D2E6B65792E792E746F646179297D6528223C6469763E222C7B22636C617373223A226461746564726F7070657220222B4D2B2220222B432B2220222B632B2220222B792C69643A692C68746D6C3A6528';
wwv_flow_api.g_varchar2_table(207) := '223C6469763E222C7B22636C617373223A227069636B6572227D297D292E617070656E64546F2822626F647922292C723D7B69643A692C696E7075743A612C656C656D656E743A65282223222B69297D3B666F7228766172204620696E206E5B695D2E6B';
wwv_flow_api.g_varchar2_table(208) := '6579296528223C756C3E222C7B22636C617373223A227069636B207069636B2D222B462C22646174612D6B223A467D292E617070656E64546F287A28222E7069636B65722229292C502846293B6966286E5B695D2E6C61726765297B6528223C6469763E';
wwv_flow_api.g_varchar2_table(209) := '222C7B22636C617373223A227069636B2D6C67227D292E696E736572744265666F7265287A28222E7069636B2D642229292C6528273C756C20636C6173733D227069636B2D6C672D68223E3C2F756C3E3C756C20636C6173733D227069636B2D6C672D62';
wwv_flow_api.g_varchar2_table(210) := '223E3C2F756C3E27292E617070656E64546F287A28222E7069636B2D6C672229293B666F7228766172204F3D6A28292C453D303B373E453B452B2B296528223C6C693E222C7B68746D6C3A745B6E5B722E69645D2E6C616E675D2E7765656B646179732E';
wwv_flow_api.g_varchar2_table(211) := '73686F72745B4F5B455D5D7D292E617070656E64546F287A28222E7069636B2D6C67202E7069636B2D6C672D682229293B666F722876617220453D303B34323E453B452B2B296528223C6C693E22292E617070656E64546F287A28222E7069636B2D6C67';
wwv_flow_api.g_varchar2_table(212) := '202E7069636B2D6C672D622229297D6528223C6469763E222C7B22636C617373223A227069636B2D62746E73227D292E617070656E64546F287A28222E7069636B65722229292C6528223C6469763E222C7B22636C617373223A227069636B2D7375626D';
wwv_flow_api.g_varchar2_table(213) := '6974227D292E617070656E64546F287A28222E7069636B2D62746E732229292C6E5B722E69645D2E7472616E736C61746526266528223C6469763E222C7B22636C617373223A227069636B2D62746E207069636B2D62746E2D6C6E67227D292E61707065';
wwv_flow_api.g_varchar2_table(214) := '6E64546F287A28222E7069636B2D62746E732229292C6E5B722E69645D2E6C6172676526266528223C6469763E222C7B22636C617373223A227069636B2D62746E207069636B2D62746E2D737A227D292E617070656E64546F287A28222E7069636B2D62';
wwv_flow_api.g_varchar2_table(215) := '746E732229292C282259223D3D647C7C226D223D3D64292626287A28222E7069636B2D642C2E7069636B2D62746E2D737A22292E6869646528292C722E656C656D656E742E616464436C61737328227069636B65722D74696E7922292C2259223D3D6426';
wwv_flow_api.g_varchar2_table(216) := '267A28222E7069636B2D6D2C2E7069636B2D62746E2D6C6E6722292E6869646528292C226D223D3D6426267A28222E7069636B2D7922292E686964652829292C702626286C3D21302C712829292C723D6E756C6C7D7D292E666F6375732866756E637469';
wwv_flow_api.g_varchar2_table(217) := '6F6E2861297B612E70726576656E7444656661756C7428292C652874686973292E626C757228292C7226264C28292C723D7B69643A652874686973292E646174612822696422292C696E7075743A652874686973292C656C656D656E743A65282223222B';
wwv_flow_api.g_varchar2_table(218) := '652874686973292E64617461282269642229297D2C7028292C4628292C4728292C4E28292C722E656C656D656E742E686173436C61737328227069636B65722D6D6F64616C22292626652822626F647922292E617070656E6428273C64697620636C6173';
wwv_flow_api.g_varchar2_table(219) := '733D227069636B65722D6D6F64616C2D6F7665726C6179223E3C2F6469763E27297D297D7D286A5175657279293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395085514442574698)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/lib/Datedropper3/datedropper.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := 'E40800003008000001000200000000000200050900000000000001009001000000004C5001000000000000000000000000000000010000000000000077CE542B00000000000000000000000000000000000016006400610074006500640072006F007000';
wwv_flow_api.g_varchar2_table(2) := '70006500720000000E0052006500670075006C006100720000001600560065007200730069006F006E00200031002E003000000016006400610074006500640072006F0070007000650072000000000000010000000D0080000300504646544D74FB9962';
wwv_flow_api.g_varchar2_table(3) := '000008140000001C4744454600370006000007F4000000204F532F324FFB5CAF0000015800000056636D61700B110F44000001CC0000016867617370FFFF0003000007EC00000008676C79660BBC123D0000034C000002986865616409DC378F000000DC';
wwv_flow_api.g_varchar2_table(4) := '0000003668686561042F02050000011400000024686D747806BD007F000001B00000001C6C6F6361035002A400000334000000166D6178700052003E00000138000000206E616D6523D0E325000005E4000001B9706F73742A75136D000007A00000004A';
wwv_flow_api.g_varchar2_table(5) := '00010000000100002B54CE775F0F3CF5000B020000000000D45EFB4900000000D45EFB4900000000020002000000000800020000000000000001000002000000002E020000000000020000010000000000000000000000000000000400010000000A003B';
wwv_flow_api.g_varchar2_table(6) := '00060000000000020000000100010000004000000000000000010200019000050008014C016600000047014C0166000000F500190084000002000509000000000000000000010000000000000000000000005066456400400061006A01E0FFE0002E0200';
wwv_flow_api.g_varchar2_table(7) := '0000000000010000000000000200000000000000020000000200000000170004007B007B002B000000000003000000030000001C0001000000000062000300010000001C000400460000000C0008000200040000006300660068006AFFFF000000000061';
wwv_flow_api.g_varchar2_table(8) := '00650068006AFFFF00000000FFA0FF9FFF9900010000000A00000000000000000008000400090000010600000100000000000000010200000002000000000000000000000000000000010000000000000000000000000000000000000000000000000000';
wwv_flow_api.g_varchar2_table(9) := '00000000000000000000000000000000000000000000000000000000000000000000000000000000000804090005060007000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
wwv_flow_api.g_varchar2_table(10) := '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
wwv_flow_api.g_varchar2_table(11) := '00000000000000000042009600B600E2010C012C014C000000030000001701FF01F0001D0020002800003F0127262733161F0137363F0121353335331533152307060F011707270725332713272307231333132D7E09231B1217210A0B371B06FEE5AE15';
wwv_flow_api.g_varchar2_table(12) := 'AE45041C3C0B4308487C01127A3D611C8A1C12641E65777E0A27332B240C0C3F4D13153232150B5B430B4216497E0FA5FEFB4B4B0110FEF000060017000001E90200000B000F0022002A0032003A00002901223511343321321511142521112125223534';
wwv_flow_api.g_varchar2_table(13) := '26232206151423223534363216151406223D0134321D013622263436321614262206141632363401DFFE420A0A01BE0AFE4301A8FE5801900B68494A670B0A74A474BB161609281C1C281C2516101016100B01240B0BFEDC0B1501100A0B4968674A0B0B';
wwv_flow_api.g_varchar2_table(14) := '527474520BE40B3E0A0A3E391C281C1C282F10161010160000010004005201FC01B0000F000037222F0126361F010136321716070106AA0402A0070E069901450209020707FEB5045202A0070E0799014403030707FEB5020002007B0004018501FC000B';
wwv_flow_api.g_varchar2_table(15) := '0016000025222F012637361F01160706052227263F0136160F0106017E0503FB07070708FB070703FF0003040707FB080E07FB03F703F307080707F3070704F3040707F3070E08F3030000000002007B0004018501FC000B0016000037323F013627260F';
wwv_flow_api.g_varchar2_table(16) := '01061716053237362F0126061F0116820503FB07070708FB070703010003040707FB080E07FB03F703F307080707F3070704F3040707F3070E08F3030002002B002B01D501D500080011000001270735231533352307153307173715333501D50BAD108C';
wwv_flow_api.g_varchar2_table(17) := '71C171AD0BAD1001CA0BAD718C102A10AD0BAD718C0000000002000000000200020000080011000001173715333523153301352337270735231501100DD013A888FEC888D00DD013011D0DD088A813FE1313D00DD088A8000000000C0096000100000000';
wwv_flow_api.g_varchar2_table(18) := '0001000B001800010000000000020007003400010000000000030028008E0001000000000004000B00CF0001000000000005000B00F30001000000000006000B01170003000104090001001600000003000104090002000E002400030001040900030050';
wwv_flow_api.g_varchar2_table(19) := '003C0003000104090004001600B70003000104090005001600DB0003000104090006001600FF006400610074006500640072006F007000700065007200006461746564726F70706572000052006500670075006C006100720000526567756C6172000046';
wwv_flow_api.g_varchar2_table(20) := '006F006E00740046006F00720067006500200032002E00300020003A0020006400610074006500640072006F00700070006500720020003A002000320036002D00310031002D00320030003100360000466F6E74466F72676520322E30203A2064617465';
wwv_flow_api.g_varchar2_table(21) := '64726F70706572203A2032362D31312D3230313600006400610074006500640072006F007000700065007200006461746564726F707065720000560065007200730069006F006E00200031002E0030000056657273696F6E20312E300000640061007400';
wwv_flow_api.g_varchar2_table(22) := '6500640072006F007000700065007200006461746564726F70706572000000000002000000000000000000000000000100000000000000000000000000000000000A0000000100020102010301040055004F01050106036C6E67036C6B6403636B64036D';
wwv_flow_api.g_varchar2_table(23) := '696E03657870000000000001FFFF000200010000000E00000018000000000002000100030009000100040000000200000000000100000000CC3DA2CF00000000D45EFB4900000000D45EFB49';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395086390667574701)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/lib/Datedropper3/src/datedropper.eot'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '3C3F786D6C2076657273696F6E3D22312E3022207374616E64616C6F6E653D226E6F223F3E0A3C21444F435459504520737667205055424C494320222D2F2F5733432F2F4454442053564720312E312F2F454E222022687474703A2F2F7777772E77332E';
wwv_flow_api.g_varchar2_table(2) := '6F72672F47726170686963732F5356472F312E312F4454442F73766731312E647464223E0A3C73766720786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F737667223E0A3C6D657461646174613E47656E657261746564206279';
wwv_flow_api.g_varchar2_table(3) := '20466F6E7461737469632E6D653C2F6D657461646174613E0A3C646566733E0A3C666F6E742069643D226461746564726F707065722220686F72697A2D6164762D783D22353132223E0A3C666F6E742D6661636520666F6E742D66616D696C793D226461';
wwv_flow_api.g_varchar2_table(4) := '746564726F707065722220756E6974732D7065722D656D3D223531322220617363656E743D22343830222064657363656E743D222D3332222F3E0A3C6D697373696E672D676C79706820686F72697A2D6164762D783D2235313222202F3E0A0A3C676C79';
wwv_flow_api.g_varchar2_table(5) := '706820676C7970682D6E616D653D226C6E672220756E69636F64653D2226233130363B2220643D224D3435203131396C313236203132362D39203130632D32352032382D34352035382D36322039306C313820306331352D32382033342D35352035362D';
wwv_flow_api.g_varchar2_table(6) := '37396C31302D3132203131203132633336203431203634203838203832203134306C362031392D323833203020302032312031373420302030203530203231203020302D353020313734203020302D32312D363920302D342D3131632D31382D35382D34';
wwv_flow_api.g_varchar2_table(7) := '372D3131322D38382D3135386C2D31312D31312036372D36362D382D32322D37322037332D3132342D3132367A206D32383920306C31323220302D3631203136357A206D3135382D39366C2D32382037352D31333820302D32382D37352D313820302031';
wwv_flow_api.g_varchar2_table(8) := '3030203237322033302030203130312D3237327A222F3E0A3C676C79706820676C7970682D6E616D653D226C6B642220756E69636F64653D22262339383B2220643D224D34373920306C2D3434362030632D3620302D313020352D31302031316C302032';
wwv_flow_api.g_varchar2_table(9) := '39326330203620342031312031302031316C3434362030633620302031302D352031302D31316C302D32393263302D362D342D31312D31302D31317A206D2D3433352032316C34323420302030203237322D34323420307A206D34303020323832632D36';
wwv_flow_api.g_varchar2_table(10) := '20302D313120352D313120313120302039372D3739203137372D313737203137372D393820302D3137372D37392D3137372D31373720302D362D352D31312D31312D31312D3520302D313020352D31302031312030203130392038392031393820313938';
wwv_flow_api.g_varchar2_table(11) := '20313938203130392030203139382D3839203139382D31393820302D362D352D31312D31302D31317A206D2D3138382D323238632D3620302D313120352D31312031316C30203632633020352035203130203131203130203620302031312D352031312D';
wwv_flow_api.g_varchar2_table(12) := '31306C302D363263302D362D352D31312D31312D31317A206D30203638632D323720302D34382032312D3438203438203020323620323120343820343820343820323720302034382D32322034382D343820302D32372D32312D34382D34382D34387A20';
wwv_flow_api.g_varchar2_table(13) := '6D30203735632D313520302D32372D31332D32372D323720302D31352031322D32372032372D3237203135203020323720313220323720323720302031342D31322032372D32372032377A222F3E0A3C676C79706820676C7970682D6E616D653D22636B';
wwv_flow_api.g_varchar2_table(14) := '642220756E69636F64653D2226233130313B2220643D224D313730203832632D3220302D3520312D3620326C2D31363020313630632D3420342D34203130203020313420342034203130203420313320306C3135332D3135332033323520333234633320';
wwv_flow_api.g_varchar2_table(15) := '342031302034203133203020342D3420342D313020302D31346C2D3333312D333331632D322D312D342D322D372D327A222F3E0A3C676C79706820676C7970682D6E616D653D22722220756E69636F64653D2226233130323B2220643D224D3338322032';
wwv_flow_api.g_varchar2_table(16) := '3437632D3320302D3620312D3820336C2D32353120323433632D3420342D34203131203020313520342034203130203420313520306C3235312D32343363342D3420342D313020302D31342D322D332D352D342D372D347A206D2D3235322D323433632D';
wwv_flow_api.g_varchar2_table(17) := '3220302D3520322D3720342D3420342D3420313020302031346C32353120323433633520342031312034203135203020342D3420342D313120302D31356C2D3235312D323433632D322D322D352D332D382D337A222F3E0A3C676C79706820676C797068';
wwv_flow_api.g_varchar2_table(18) := '2D6E616D653D226C2220756E69636F64653D2226233130343B2220643D224D313330203234376333203020362031203820336C3235312032343363342034203420313120302031352D3420342D313020342D313520306C2D3235312D323433632D342D34';
wwv_flow_api.g_varchar2_table(19) := '2D342D313020302D313420322D3320352D3420372D347A206D3235322D32343363322030203520322037203420342034203420313020302031346C2D32353120323433632D3520342D313120342D313520302D342D342D342D313120302D31356C323531';
wwv_flow_api.g_varchar2_table(20) := '2D32343363322D3220352D3320382D337A222F3E0A3C676C79706820676C7970682D6E616D653D226D696E2220756E69636F64653D22262339373B2220643D224D343639203435386C2D31312031312D3137332D3137332030203131332D313620302030';
wwv_flow_api.g_varchar2_table(21) := '2D31343020313430203020302031362D31313320307A206D2D3336362D3231356C302D31362031313320302D3137332D3137332031312D3131203137332031373320302D31313320313620302030203134307A222F3E0A3C676C79706820676C7970682D';
wwv_flow_api.g_varchar2_table(22) := '6E616D653D226578702220756E69636F64653D22262339393B2220643D224D323732203238356C31332D3133203230382032303820302D31333620313920302030203136382D313638203020302D31392031333620307A206D2D3130342D3238356C3020';
wwv_flow_api.g_varchar2_table(23) := '31392D313336203020323038203230382D31332031332D3230382D3230382030203133362D3139203020302D3136387A222F3E0A3C2F666F6E743E3C2F646566733E3C2F7376673E0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395087205588574703)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/lib/Datedropper3/src/datedropper.svg'
,p_mime_type=>'image/svg+xml'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '00010000000D0080000300504646544D74FB9962000008140000001C4744454600370006000007F4000000204F532F324FFB5CAF0000015800000056636D61700B110F44000001CC0000016867617370FFFF0003000007EC00000008676C79660BBC123D';
wwv_flow_api.g_varchar2_table(2) := '0000034C000002986865616409DC378F000000DC0000003668686561042F02050000011400000024686D747806BD007F000001B00000001C6C6F6361035002A400000334000000166D6178700052003E00000138000000206E616D6523D0E325000005E4';
wwv_flow_api.g_varchar2_table(3) := '000001B9706F73742A75136D000007A00000004A00010000000100002B54CE775F0F3CF5000B020000000000D45EFB4900000000D45EFB4900000000020002000000000800020000000000000001000002000000002E0200000000000200000100000000';
wwv_flow_api.g_varchar2_table(4) := '00000000000000000000000400010000000A003B00060000000000020000000100010000004000000000000000010200019000050008014C016600000047014C0166000000F5001900840000020005090000000000000000000100000000000000000000';
wwv_flow_api.g_varchar2_table(5) := '00005066456400400061006A01E0FFE0002E02000000000000010000000000000200000000000000020000000200000000170004007B007B002B000000000003000000030000001C0001000000000062000300010000001C000400460000000C00080002';
wwv_flow_api.g_varchar2_table(6) := '00040000006300660068006AFFFF00000000006100650068006AFFFF00000000FFA0FF9FFF9900010000000A0000000000000000000800040009000001060000010000000000000001020000000200000000000000000000000000000001000000000000';
wwv_flow_api.g_varchar2_table(7) := '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080409000506000700030000000000000000000000000000000000000000000000000000000000';
wwv_flow_api.g_varchar2_table(8) := '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
wwv_flow_api.g_varchar2_table(9) := '000000000000000000000000000000000000000000000000000000000042009600B600E2010C012C014C000000030000001701FF01F0001D0020002800003F0127262733161F0137363F0121353335331533152307060F01170727072533271327230723';
wwv_flow_api.g_varchar2_table(10) := '1333132D7E09231B1217210A0B371B06FEE5AE15AE45041C3C0B4308487C01127A3D611C8A1C12641E65777E0A27332B240C0C3F4D13153232150B5B430B4216497E0FA5FEFB4B4B0110FEF000060017000001E90200000B000F0022002A0032003A0000';
wwv_flow_api.g_varchar2_table(11) := '290122351134332132151114252111212522353426232206151423223534363216151406223D0134321D013622263436321614262206141632363401DFFE420A0A01BE0AFE4301A8FE5801900B68494A670B0A74A474BB161609281C1C281C2516101016';
wwv_flow_api.g_varchar2_table(12) := '100B01240B0BFEDC0B1501100A0B4968674A0B0B527474520BE40B3E0A0A3E391C281C1C282F10161010160000010004005201FC01B0000F000037222F0126361F010136321716070106AA0402A0070E069901450209020707FEB5045202A0070E079901';
wwv_flow_api.g_varchar2_table(13) := '4403030707FEB5020002007B0004018501FC000B0016000025222F012637361F01160706052227263F0136160F0106017E0503FB07070708FB070703FF0003040707FB080E07FB03F703F307080707F3070704F3040707F3070E08F3030000000002007B';
wwv_flow_api.g_varchar2_table(14) := '0004018501FC000B0016000037323F013627260F01061716053237362F0126061F0116820503FB07070708FB070703010003040707FB080E07FB03F703F307080707F3070704F3040707F3070E08F3030002002B002B01D501D500080011000001270735';
wwv_flow_api.g_varchar2_table(15) := '231533352307153307173715333501D50BAD108C71C171AD0BAD1001CA0BAD718C102A10AD0BAD718C0000000002000000000200020000080011000001173715333523153301352337270735231501100DD013A888FEC888D00DD013011D0DD088A813FE';
wwv_flow_api.g_varchar2_table(16) := '1313D00DD088A8000000000C00960001000000000001000B001800010000000000020007003400010000000000030028008E0001000000000004000B00CF0001000000000005000B00F30001000000000006000B01170003000104090001001600000003';
wwv_flow_api.g_varchar2_table(17) := '000104090002000E002400030001040900030050003C0003000104090004001600B70003000104090005001600DB0003000104090006001600FF006400610074006500640072006F007000700065007200006461746564726F7070657200005200650067';
wwv_flow_api.g_varchar2_table(18) := '0075006C006100720000526567756C6172000046006F006E00740046006F00720067006500200032002E00300020003A0020006400610074006500640072006F00700070006500720020003A002000320036002D00310031002D00320030003100360000';
wwv_flow_api.g_varchar2_table(19) := '466F6E74466F72676520322E30203A206461746564726F70706572203A2032362D31312D3230313600006400610074006500640072006F007000700065007200006461746564726F707065720000560065007200730069006F006E00200031002E003000';
wwv_flow_api.g_varchar2_table(20) := '0056657273696F6E20312E3000006400610074006500640072006F007000700065007200006461746564726F70706572000000000002000000000000000000000000000100000000000000000000000000000000000A0000000100020102010301040055';
wwv_flow_api.g_varchar2_table(21) := '004F01050106036C6E67036C6B6403636B64036D696E03657870000000000001FFFF000200010000000E00000018000000000002000100030009000100040000000200000000000100000000CC3DA2CF00000000D45EFB4900000000D45EFB49';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395088188203574706)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/lib/Datedropper3/src/datedropper.ttf'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '774F46464F54544F00000608000B0000000008680001000000000000000000000000000000000000000000004346462000000108000002C1000003533DC9C1A74646544D000003CC0000001A0000001C74FB996247444546000003E80000001D00000020';
wwv_flow_api.g_varchar2_table(2) := '003500044F532F32000004080000004500000060501D5ED0636D6170000004500000005A000001680800093E68656164000004AC000000290000003609DC378F68686561000004D80000001800000024042F0203686D7478000004F00000001400000014';
wwv_flow_api.g_varchar2_table(3) := '04BA00796D617870000005040000000600000006000850006E616D650000050C000000E9000001B923D0E325706F7374000005F8000000100000002000030001789C4D924D681341188667D24CB2AD695A835B5A5C9288A0A0F452042906213DE9A1207A';
wwv_flow_api.g_varchar2_table(4) := '1041043545A47FF1A731A5B1B5D8CD66F325D95D8D49AD5A538CADA78A20520F1E3C087A100541B4225EBCF6FC2D7C429DA52ACE69E69DF79967961DCEFC7EC6390FA5CE5E1D4A5D1E4FA7872E33EE639C25DDB8CFDDD5E276FB4B210EA11608F9A36DAC';
wwv_flow_api.g_varchar2_table(5) := 'E7446413E0DF24140470AB6E5568EC4E87C658A7C69ADB35D6ADB51C8AB0A0778C9F05591B6B679D6C27DB333276616438757E38357A716C289BFECFF9BF9E316EF00237D90936C88B1C98E21DE463D7783B1FE4ABBE0EDF51DFCDF01A6E531772D88991';
wwv_flow_api.g_varchar2_table(6) := '4F03B7978EBCAFD5C4F3974F5E3F78A358B58F000D1A0078950138E54D32F814F4AC983C397EFAC239E5C6CC6C5D4C3CCA2EE75694C9C0FDE187A3CD71A53A2BF02045D4B7D8FF96FAC5D3FDEA22ECC1E628ECA5E60358F98C511061F74A9763D94E0CD7';
wwv_flow_api.g_varchar2_table(7) := '828E61EBD15FC703BA91D763B416D4ADBC13AD35546CBA096A06AFE0AA6ADBB683BCEF2771E27D7DC4753B6F3B32DB585FDFD8583FB44FAE9D181DA3ACEAA5B17741B9AFEBF97C3E3A18F4F6A21FFCCB8DC6F2E3CC523A9D99B8946E6496639FFD0BF5E9';
wwv_flow_api.g_varchar2_table(8) := 'EBB999995C6EA6BE70B73EBF100BE3E1EF6A05CAA57249C11FF8435816388655B0E6A06028F495BE502FF68A82A5832107E896A1E0013A204AC54AB10C4AD88D20A865A894CA952D54210B0D91FF0BCC79804586289B95620514B2C99042D92FCB5C3625';
wwv_flow_api.g_varchar2_table(9) := '75CBB00CD9CF4BA1D7DCD2C8BEE909B04B0A4C2894CC8A210596B585D99603929202E30F669A85620114F40405AF5FDEBA8AA46E59723860FFB98AA474C3907DD3F4BEE0A27B46A5242551004C511C00E3F700486012938290322AC6293E8522E0B56ED4';
wwv_flow_api.g_varchar2_table(10) := 'BC9C84FCA3D8C4672AA630451AC022262494C84A5CA314A504B55253A5042616490B78ADF9692F47CD7B0BD51DA0C20BB7E75B1102D136BE7B6233D45A0FB5FD0627A4825E000000789C6360606064008233B68BCE83E82B71BF3D6134004ED107680000';
wwv_flow_api.g_varchar2_table(11) := '789C6360646060E00362090610606260044276206601F318000497003A000000789C63606662609CC0C0CAC0C1E8C398C6C0C0E00EA5BF324832B430303031B07232C0002303120848734D6170604864C8627CF0FF01831E13921A305B01081901D0BF09';
wwv_flow_api.g_varchar2_table(12) := '94000000789CB58DDD0980300C06AF3FB6228EE03CEEA1451117F249578DB12ABE0B3D08C941BE0470DCD561B818D54C764FAFBDA5C6EA0C8999855524EF0D4C9FC921BB6C39D7F0123417C1049ED3050936E23C55F94FBF38016D530D460000789C6360';
wwv_flow_api.g_varchar2_table(13) := '64606000E2AB770E7D89E7B7F9CAC0CDC4000257E27E7B22D34C0C60710E08050054900A10000000789C63606460606200023D3009623332A002260005D0003902000000020000000017000100780078002B00000000500000080000789C8D8E318EC230';
wwv_flow_api.g_varchar2_table(14) := '10457F20B05AB1DA12285D6CB14D22DB4229D0D6D488823E52AC0809C59109D7A0E42A7B0C0EC03138C0EE77988282028FACFF66FC673C003E70468278124C30171EE00D0BE121BE71124EE9B9088FC837E13126C98CCE247D6765DA77451EE0135FC243';
wwv_flow_api.g_varchar2_table(15) := 'ACF1239CD2F32B3C225F85C7E43F5428D1C151033C5A8623A12A3B5705DFB68EC986B51A47ECE98DA9AB8FFB92B06247C3EEA8810E07058B1C9ABAE47D3EFBFE665120836164644D2D38D037DDCA87DA299B6BB5540F5B30B345664C66B5A1F395B5B77D';
wwv_flow_api.g_varchar2_table(16) := 'ED805DBFA6E21771356C5D38EC7CA34CAE5F9AF30F284347C3000000789C63606640068C0C680000008E0005';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(31395088960751574709)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/lib/Datedropper3/src/datedropper.woff'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F476C6F62616C204E616D6573706163650D0A76617220617065784461746544726F70706572203D207B0D0A2020696E69744461746544726F707065723A2066756E6374696F6E28704974656D49642C20704F7074696F6E732C20704C6F6767696E67';
wwv_flow_api.g_varchar2_table(2) := '29207B0D0A202020202428272327202B20704974656D4964292E6461746544726F7070657228293B0D0A0D0A2020202076617220764461746544726F707065724964203D202428272327202B20704974656D4964292E646174612827696427293B0D0A20';
wwv_flow_api.g_varchar2_table(3) := '2020200D0A202020207661722076557365724167656E74203D2066756E6374696F6E2829207B0D0A2020202020206966282F416E64726F69647C7765624F537C6950686F6E657C695061647C69506F647C426C61636B42657272797C49454D6F62696C65';
wwv_flow_api.g_varchar2_table(4) := '7C4F70657261204D696E692F692E74657374286E6176696761746F722E757365724167656E7429290D0A202020202020202072657475726E20747275653B0D0A202020202020656C73650D0A202020202020202072657475726E2066616C73653B0D0A20';
wwv_flow_api.g_varchar2_table(5) := '2020207D3B0D0A0D0A202020207661722076546F7563684576656E74203D2076557365724167656E742829203F2027746F756368737461727427203A20276D6F757365646F776E273B0D0A0D0A202020202428617065782E6750616765436F6E74657874';
wwv_flow_api.g_varchar2_table(6) := '24292E6F6E2876546F7563684576656E742C20276469762327202B20764461746544726F707065724964202B20272E6461746564726F707065722E7069636B65722D666F637573202E7069636B2D7375626D6974272C2066756E6374696F6E2829207B0D';
wwv_flow_api.g_varchar2_table(7) := '0A2020202020202428272327202B20704974656D4964292E747269676765722827617065782D6461746564726F707065722D6368616E676527293B0D0A202020207D293B0D0A20207D0D0A7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(37340869810953983579)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/js/apexdatedropper.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220617065784461746544726F707065723D7B696E69744461746544726F707065723A66756E6374696F6E28652C722C74297B24282223222B65292E6461746544726F7070657228293B76617220613D24282223222B65292E646174612822696422';
wwv_flow_api.g_varchar2_table(2) := '292C693D66756E6374696F6E28297B72657475726E21212F416E64726F69647C7765624F537C6950686F6E657C695061647C69506F647C426C61636B42657272797C49454D6F62696C657C4F70657261204D696E692F692E74657374286E617669676174';
wwv_flow_api.g_varchar2_table(3) := '6F722E757365724167656E74297D2C6F3D6928293F22746F7563687374617274223A226D6F757365646F776E223B2428617065782E6750616765436F6E7465787424292E6F6E286F2C2264697623222B612B222E6461746564726F707065722E7069636B';
wwv_flow_api.g_varchar2_table(4) := '65722D666F637573202E7069636B2D7375626D6974222C66756E6374696F6E28297B24282223222B65292E747269676765722822617065782D6461746564726F707065722D6368616E676522297D297D7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(37340870353082983957)
,p_plugin_id=>wwv_flow_api.id(31245697109785470074)
,p_file_name=>'server/js/apexdatedropper.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
