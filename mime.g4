grammar mime;

axiom: s EOF;

s: mime_message_headers;


/* MIME specifications */

attribute: token;

composite_type: 'message' | 'multipart' | extension_token;

content: 'Content-Type' ':' type | subtype (';' parameter)*;

description: 'Content-Description' ':' text*;

discrete_type: 'text' | 'image' | 'audio' | 'video' | 'application' | extension_token;

encoding: 'Content-Transfer-Encoding' ':' mechanism;

entity_headers: (content CRLF)? (encoding CRLF)? (id CRLF)? (description CRLF)? CRLF;

extension_token: x_token;

hex_octet: '=' (DIGIT | [A-F]){2};

id: 'Content-ID' ':' msg_id;

mechanism: '7bit' | '8bit' | 'binary' | 'quoted-printable' | 'base64' | x_token;

mime_message_headers: entity_headers fields version CRLF;

parameter: attribute '=' value;

ptext: hex_octet | safe_char;

qp_line: (qp_segment transport_padding CRLF)* qp_part transport_padding;

qp_part: qp_section;

qp_section: ((ptext | SP | TAB)* ptext)?;

qp_segment: qp_section (SP | TAB)* '=';

quoted_printable: qp_line (CRLF qp_line)*;

safe_char: '\u0021'..'\u003c' | '\u003e'..'\u007e';

subtype: extension_token;

token: safe_char+;

transport_padding: LWSP;

type: discrete_type | composite_type;

value: token | quoted_string;

version: 'MIME-Version' ':' DIGIT+ '.' DIGIT+;

x_token: ('X-'|'x-') token;


/* Primitive tokens */

NO_WS_CTL: '\u0001'..'\u0008' | '\u000b' | '\u000c' | '\u000e'..'\u001f' | '\u007f';

text: '\u0001'..'\u0009' | '\u000b'..'\u007e';

quoted_pair: [\\] text;

FWS: (WSP* CRLF)? WSP+;

ctext: NO_WS_CTL | '\u0021'..'\u0027' | '\u002a'..'\u005b' | '\u005d'..'\u007e';

ccontent: ctext | quoted_pair | comment;

comment: '(' (FWS? ccontent)* FWS? ')';

CFWS: (FWS? comment)* (FWS? comment | FWS);

atext: ALPHA | DIGIT | '!' | '#' | '$' | '%' | '&' | QUOTE | '*' | '+' | '-' | '/' | '=' | '?' | '^' | '_' | '`' | '{' | '}' | '|' | '~';

atom: CFWS? atext+ CFWS?;

dot_atom: CFWS? dot_atom_text CFWS?;

dot_atom_text: atext+ ('.' atext)*;

qtext: NO_WS_CTL | '\u0021' | '\u0023'..'\u005b' | '\u00d5'..'\u007e';

qcontent: qtext | quoted_pair;

quoted_string: CFWS? DQUOTE (FWS? qcontent)* FWS? DQUOTE CFWS?;

word: atom | quoted_string;

phrase: word+;

utext: NO_WS_CTL | '\u0021'..'\u007e';

unstructured: (FWS? utext)* FWS?;



/* Date specifications */

date_time: (day_of_week ',')? date FWS time CFWS?;

day_of_week: FWS? day_name;

day_name: 'Mon' | 'Tue' | 'Wed' | 'Thu' | 'Fri' | 'Sat' | 'Sun';

date: day month year;

year: DIGIT{4};

month: FWS month_name FWS;

month_name: 'Jan' | 'Feb' | 'Mar' | 'Apr' | 'May' | 'Jun' | 'Jul' | 'Aug' | 'Sep' | 'Oct' | 'Nov' | 'Dec';

day: FWS? DIGIT{1,2};

time: time_of_day FWS zone;

time_of_day: hour ':' minute (':' second)?;

hour: DIGIT{2};

minute: DIGIT{2};

second: DIGIT{2};

zone: ('+'|'-') DIGIT{4};


/* Address specification */

address: mailbox | group;

mailbox: name_addr | addr_spec;

name_addr: display_name? angle_addr;

angle_addr: CFWS? '<' addr_spec '>' CFWS?;

group: display_name ':' (mailbox_list | CFWS)? ';' CFWS?;

display_name: phrase;

mailbox_list: mailbox (',' mailbox)*;

address_list: address (',' address)*;

addr_spec: local_part '@' domain;

local_part: dot_atom | quoted_string;

domain: dot_atom | domain_literal;

domain_literal: CFWS? '[' (FWS? dcontent)* FWS? ']' CFWS?;

dcontent: dtext | quoted_pair;

dtext: NO_WS_CTL | '\u0021'..'\u005a' | '\u005e'..'\u007e';


/* Overall message syntax */

message: fields (CRLF body)?;

body: (text* CRLF)* text*;


/* Fields definition */

fields: (trace (resent_date | resent_from | resent_sender | resent_to | resent_cc | resent_bcc | resent_msg_id)*)* (orig_date | r_from | sender | reply_to | to | cc | bcc | message_id | in_reply_to | references | subject | comments | keywords | optional_field)*;

orig_date: 'Date:' date_time CRLF;

r_from: 'From:' mailbox_list CRLF;

sender: 'Sender:' mailbox CRLF;

reply_to: 'Reply-To:' address_list CRLF;

to: 'To:' address_list CRLF;

cc: 'Cc:' address_list CRLF;

bcc: 'Bcc' (address_list | CFWS?) CRLF;

message_id: 'Message-ID:' msg_id CRLF;

in_reply_to: 'In-Reply-To:' msg_id+ CRLF;

references: 'References:' msg_id+ CRLF;

msg_id: CFWS? '<' id_left '@' id_right '>' CFWS?;

id_left: dot_atom_text | no_fold_quote;

id_right: dot_atom_text | no_fold_literal;

no_fold_quote: DQUOTE (qtext | quoted_pair)* DQUOTE;

no_fold_literal: '[' (dtext | quoted_pair)* ']';

subject: 'Subject:' unstructured CRLF;

comments: 'Comments:' unstructured CRLF;

keywords: 'Keywords:' phrase (',' phrase)* CRLF;

resent_date: 'Resent-Date:' date_time CRLF;

resent_from: 'Resent-From:' mailbox_list CRLF;

resent_sender: 'Resent-Sender:' mailbox CRLF;

resent_to: 'Resent-To:' address_list CRLF;

resent_cc: 'Resent-Cc:' address_list CRLF;

resent_bcc: 'Resent-Bcc:' (address_list | CFWS?) CRLF;

resent_msg_id: 'Resent-Message-ID:' msg_id CRLF;

trace: r_return? received+;

r_return: 'Return-Path:' path CRLF;

path: (CFWS? '<' (CFWS? | addr_spec) '>' CFWS?;

received: 'Received:' name_val_list ';' date_time CRLF;

name_val_list: CFWS? (name_val_pair (CFWS name_val_pair)*)?;

name_val_pair: item_name CFWS item_value;

item_name: ALPHA ([-]? (ALPHA|DIGIT))*;

item_value: angle_addr+ | addr_spec | atom | domain | msg_id;

optional_field: field_name ':' unstructured CRLF;

field_name: ftext+;

ftext: '\u0021'..'\u0039' | '\u003b'..'\u007e';


/* Les fragments de base */

DIGIT: [0-9];

ALPHA: [a-zA-Z];

QUOTE: ["];

DQUOTE: ['];

LWSP: (WSP | CRLF WSP)*;

WSP: SP | TAB;

CRLF: CR LF;

CR: '\u000d';

LF: '\u000a';

SP: '\u0020';

TAB: '\u0009';

































