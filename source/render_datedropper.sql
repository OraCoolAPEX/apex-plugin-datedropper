procedure render_datedropper (
  p_item   in            apex_plugin.t_item,
  p_plugin in            apex_plugin.t_plugin,
  p_param  in            apex_plugin.t_item_render_param,
  p_result in out nocopy apex_plugin.t_item_render_result )
is
  l_logging              boolean;
  l_default_date         varchar2(10);
  l_disabled_days        varchar2(4000);
  l_format               varchar2(6);
  l_fx                   varchar2(5);
  l_fx_mobile            varchar2(5);
  l_init_set             varchar2(5);
  l_lang                 varchar2(2);
  l_large_mode           varchar2(5);
  l_large_default        varchar2(5);
  l_lock                 varchar2(5);
  l_jump                 number;
  l_max_year             varchar2(4);
  l_min_year             varchar2(4);
  l_modal                varchar2(5);
  l_theme                varchar2(10);
  l_translate_mode       varchar2(5);
  l_html                 varchar2(4000);
  --
  --Convert Yes/No To True/False VARCHAR2 Type
  --
  function yn_to_tf_vc ( p_yn  in varchar2 )
  return varchar2
  is
  begin
    case when lower(p_yn) = 'y' then return 'true';
    else return 'false';
    end case;
  end yn_to_tf_vc;
begin
  --
  --Component-Level Custom Attributes
  --
  l_default_date    := p_item.attribute_01;
  l_disabled_days   := nvl(p_item.attribute_02,'false');
  l_init_set        := yn_to_tf_vc(p_item.attribute_03);
  l_large_mode      := yn_to_tf_vc(p_item.attribute_04);
  l_large_default   := yn_to_tf_vc(p_item.attribute_05);
  l_lock            := nvl(p_item.attribute_06,'false');
  l_jump            := p_item.attribute_07;
  l_max_year        := p_item.attribute_08;
  l_min_year        := p_item.attribute_09;
  l_modal           := yn_to_tf_vc(p_item.attribute_10);
  --
  --Application-Level Custom Attributes
  --
  l_format          := p_plugin.attribute_01;
  l_fx              := yn_to_tf_vc(p_plugin.attribute_02);
  l_fx_mobile       := yn_to_tf_vc(p_plugin.attribute_03);
  l_lang            := p_plugin.attribute_04;
  l_theme           := p_plugin.attribute_05;
  l_translate_mode  := yn_to_tf_vc(p_plugin.attribute_06);
  --
  --Add Theme CSS Files
  --
  case l_theme
    when 'vita_dark' then
      apex_css.add_file (
        p_name      => 'server/css/vita_dark',
        p_directory => p_plugin.file_prefix );
    when 'vita_red' then
      apex_css.add_file (
        p_name      => 'server/css/vita_red',
        p_directory => p_plugin.file_prefix );
    when 'vita_slate' then
      apex_css.add_file (
        p_name      => 'server/css/vita_slate',
        p_directory => p_plugin.file_prefix );
    else
      apex_css.add_file (
        p_name      => 'server/css/vita',
        p_directory => p_plugin.file_prefix );
  end case;
  --
  --Debug Mode
  --
  if apex_application.g_debug then
    apex_plugin_util.debug_page_item (
      p_plugin              => p_plugin,
      p_page_item           => p_item,
      p_value               => p_param.value,
      p_is_readonly         => p_param.is_readonly,
      p_is_printer_friendly => p_param.is_printer_friendly );
  end if;
  --
  --Printer Friendly Display
  --
  if p_param.is_printer_friendly then
    apex_plugin_util.print_display_only (
      p_item_name           => p_item.name,
      p_display_value       => p_param.value,
      p_show_line_breaks    => false,
      p_escape              => true,
      p_attributes          => p_item.element_attributes );

    p_result.is_navigable := false;
  --
  --Read Only Display
  --
  elsif p_param.is_readonly then
    apex_plugin_util.print_hidden_if_readonly (
      p_item_name           => p_item.name,
      p_value               => p_param.value,
      p_is_readonly         => p_param.is_readonly,
      p_is_printer_friendly => p_param.is_printer_friendly );

    p_result.is_navigable := false;
  else
    l_html := '<input type="text" id="' || p_item.name || '" name="' || p_item.name || '" ';
    
    if l_default_date   is not null then l_html := l_html || 'data-default-date="'   || l_default_date   || '" '; end if;
    if l_disabled_days  is not null then l_html := l_html || 'data-disabled-days="'  || l_disabled_days  || '" '; end if;
    if l_format         is not null then l_html := l_html || 'data-format="'         || l_format         || '" '; end if;
    if l_fx             is not null then l_html := l_html || 'data-fx="'             || l_fx             || '" '; end if;
    if l_fx_mobile      is not null then l_html := l_html || 'data-fx-mobile="'      || l_fx_mobile      || '" '; end if;
    if l_init_set       is not null then l_html := l_html || 'data-init-set="'       || l_init_set       || '" '; end if;
    if l_lang           is not null then l_html := l_html || 'data-lang="'           || l_lang           || '" '; end if;
    if l_large_mode     is not null then l_html := l_html || 'data-large-mode="'     || l_large_mode     || '" '; end if;
    if l_large_default  is not null then l_html := l_html || 'data-large-default="'  || l_large_default  || '" '; end if;
    if l_lock           is not null then l_html := l_html || 'data-lock="'           || l_lock           || '" '; end if;
    if l_jump           is not null then l_html := l_html || 'data-jump="'           || l_jump           || '" '; end if;
    if l_max_year       is not null then l_html := l_html || 'data-max-year="'       || l_max_year       || '" '; end if;
    if l_min_year       is not null then l_html := l_html || 'data-min-year="'       || l_min_year       || '" '; end if;
    if l_modal          is not null then l_html := l_html || 'data-modal="'          || l_modal          || '" '; end if;
    if l_theme          is not null then l_html := l_html || 'data-theme="'          || l_theme          || '" '; end if;
    if l_translate_mode is not null then l_html := l_html || 'data-translate-mode="' || l_translate_mode || '" '; end if;

    l_html := l_html || '/>';

    sys.htp.p(l_html);

    --
    --Logging
    --
    if apex_application.g_debug then
      l_logging := true;
    else
      l_logging := false;
    end if;

    apex_javascript.add_onload_code (
      p_code => 'apexDateDropper.initDateDropper(' ||
                   apex_javascript.add_value (
                       p_value     => p_item.name,
                       p_add_comma => true )      || '{' ||
                   apex_javascript.add_attribute (
                       p_name      => 'defaultDate',
                       p_value     => l_default_date,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'disabledDays',
                       p_value     => l_disabled_days,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'format',
                       p_value     => l_format,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'fx',
                       p_value     => l_fx,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'fxMobile',
                       p_value     => l_fx_mobile,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'initSet',
                       p_value     => l_init_set,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'lang',
                       p_value     => l_lang,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'largeMode',
                       p_value     => l_large_mode,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'largeDefault',
                       p_value     => l_large_default,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'lock',
                       p_value     => l_lock,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'jump',
                       p_value     => l_jump,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'maxYear',
                       p_value     => l_max_year,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'minYear',
                       p_value     => l_min_year,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'modal',
                       p_value     => l_modal,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'theme',
                       p_value     => l_theme,
                       p_add_comma => true )       ||
                   apex_javascript.add_attribute (
                       p_name      => 'translateMode',
                       p_value     => l_translate_mode,
                       p_add_comma => false )      || '},' ||
                   apex_javascript.add_value (
                       p_value     => l_logging,
                       p_add_comma => false ) || ');' );

    p_result.is_navigable := true;
  end if;
exception
  when others then
    raise;
end render_datedropper;