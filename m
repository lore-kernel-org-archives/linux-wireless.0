Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:54964 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3EAMor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 08:44:47 -0400
Received: from [78.46.5.203] (helo=sslproxy01.your-server.de)
	by www62.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.74)
	(envelope-from <borkmann@iogearbox.net>)
	id 1UXW2g-0005tP-JF
	for linux-wireless@vger.kernel.org; Wed, 01 May 2013 14:21:50 +0200
Received: from [212.23.233.194] (helo=[192.168.1.101])
	by sslproxy01.your-server.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <borkmann@iogearbox.net>)
	id 1UXW2c-0003LP-J5
	for linux-wireless@vger.kernel.org; Wed, 01 May 2013 14:21:47 +0200
Message-ID: <518108D7.9050206@iogearbox.net> (sfid-20130501_144452_393965_8ADAA371)
Date: Wed, 01 May 2013 14:21:43 +0200
From: Daniel Borkmann <borkmann@iogearbox.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: net-next, wireless compile warnings
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When compiling the latest net-next tree with W=1, I get these warnings
related to wireless. Not sure how much of them are actually serious:

net/mac80211/./trace.h: In function ‘ftrace_define_fields_local_sdata_addr_evt’:
net/mac80211/./trace.h:72:775: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:72:964: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_local_u32_evt’:
net/mac80211/./trace.h:95:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_local_sdata_evt’:
net/mac80211/./trace.h:115:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:115:966: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_return_u64’:
net/mac80211/./trace.h:170:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_change_interface’:
net/mac80211/./trace.h:239:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:239:966: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:239:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_config’:
net/mac80211/./trace.h:273:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:273:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:273:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:273:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:273:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:273:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_bss_info_changed’:
net/mac80211/./trace.h:315:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:315:966: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:315:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:315:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:315:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:315:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:315:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:315:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:315:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_configure_filter’:
net/mac80211/./trace.h:453:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:453:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:453:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_set_key’:
net/mac80211/./trace.h:505:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:505:966: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:505:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_update_tkip_key’:
net/mac80211/./trace.h:539:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:539:966: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:539:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_get_stats’:
net/mac80211/./trace.h:601:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:601:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:601:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:601:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_get_tkip_seq’:
net/mac80211/./trace.h:632:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_sta_notify’:
net/mac80211/./trace.h:688:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:688:966: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:688:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_sta_state’:
net/mac80211/./trace.h:716:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:716:966: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:716:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:716:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_sta_rc_update’:
net/mac80211/./trace.h:748:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:748:966: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:748:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_sta_add’:
net/mac80211/./trace.h:776:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:776:966: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_sta_remove’:
net/mac80211/./trace.h:801:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:801:966: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_conf_tx’:
net/mac80211/./trace.h:826:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:826:966: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_set_tsf’:
net/mac80211/./trace.h:867:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:867:966: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:867:777: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_ampdu_action’:
net/mac80211/./trace.h:903:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:903:2047: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:903:2236: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_flush’:
net/mac80211/./trace.h:961:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_channel_switch’:
net/mac80211/./trace.h:985:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:985:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:985:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:985:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:985:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_set_antenna’:
net/mac80211/./trace.h:1013:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1013:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_get_antenna’:
net/mac80211/./trace.h:1038:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1038:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_remain_on_channel’:
net/mac80211/./trace.h:1063:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1063:968: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:1063:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1063:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_set_ringparam’:
net/mac80211/./trace.h:1100:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1100:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_get_ringparam’:
net/mac80211/./trace.h:1123:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1123:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1123:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1123:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_set_bitrate_mask’:
net/mac80211/./trace.h:1162:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1162:968: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:1162:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1162:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_set_rekey_data’:
net/mac80211/./trace.h:1189:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1189:968: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_rssi_callback’:
net/mac80211/./trace.h:1217:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1217:968: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:1217:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_local_chanctx’:
net/mac80211/./trace.h:1330:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1330:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1330:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1330:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_change_chanctx’:
net/mac80211/./trace.h:1364:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1364:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1364:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1364:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1364:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_local_sdata_chanctx’:
net/mac80211/./trace.h:1389:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1389:968: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:1389:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1389:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1389:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1389:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_start_ap’:
net/mac80211/./trace.h:1428:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1428:968: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_api_start_tx_ba_cb’:
net/mac80211/./trace.h:1503:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1503:384: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_api_stop_tx_ba_cb’:
net/mac80211/./trace.h:1547:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1547:384: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_api_beacon_loss’:
net/mac80211/./trace.h:1575:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1575:384: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_api_connection_loss’:
net/mac80211/./trace.h:1594:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1594:384: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_api_cqm_rssi_notify’:
net/mac80211/./trace.h:1613:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1613:384: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/./trace.h:1613:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_api_chswitch_done’:
net/mac80211/./trace.h:1716:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1716:384: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_api_gtk_rekey_notify’:
net/mac80211/./trace.h:1747:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1747:384: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_api_enable_rssi_reports’:
net/mac80211/./trace.h:1768:195: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1768:384: warning: ordered comparison of pointer with null pointer [-Wextra]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_wake_queue’:
net/mac80211/./trace.h:1819:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_stop_queue’:
net/mac80211/./trace.h:1843:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/mac80211/trace.h:1953,
                  from net/mac80211/trace.c:10:
net/mac80211/./trace.h: In function ‘ftrace_define_fields_drv_set_default_unicast_key’:
net/mac80211/./trace.h:1867:779: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/mac80211/./trace.h:1867:968: warning: ordered comparison of pointer with null pointer [-Wextra]
net/mac80211/mlme.c: In function ‘ieee80211_sta_process_chanswitch’:
net/mac80211/mlme.c:1023:24: warning: variable ‘bss’ set but not used [-Wunused-but-set-variable]
[...]
net/wireless/reg.c: In function ‘restore_alpha2’:
net/wireless/reg.c:1813:3: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
[...]
net/wireless/nl80211.c: In function ‘nl80211_parse_mesh_config’:
net/wireless/nl80211.c:4682:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4685:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4688:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4690:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4693:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4700:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4700:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4706:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4713:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4717:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4721:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4726:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4729:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4732:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4736:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4742:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4749:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4752:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4762:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c:4762:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]
net/wireless/nl80211.c: In function ‘nl80211_trigger_scan’:
net/wireless/nl80211.c:5207:4: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/nl80211.c: In function ‘nl80211_set_tx_bitrate_mask’:
net/wireless/nl80211.c:7055:3: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
[...]
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_add_virtual_intf’:
net/wireless/./trace.h:314:987: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_wiphy_wdev_evt’:
net/wireless/./trace.h:331:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_change_virtual_intf’:
net/wireless/./trace.h:355:1510: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_start_ap’:
net/wireless/./trace.h:455:1510: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:455:1510: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:455:1510: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:455:1510: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:455:1510: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:455:3498: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:455:3498: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:455:4109: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_station_add_change’:
net/wireless/./trace.h:596:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:596:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:596:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_return_int_station_info’:
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:712:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_return_int_mpath_info’:
net/wireless/./trace.h:792:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:792:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:792:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:792:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:792:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:792:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_return_int_mesh_config’:
net/wireless/./trace.h:830:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:830:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:830:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:830:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_update_mesh_config’:
net/wireless/./trace.h:847:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:847:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:847:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:847:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:847:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_join_mesh’:
net/wireless/./trace.h:867:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:867:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:867:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:867:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_set_txq_params’:
net/wireless/./trace.h:916:1496: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_libertas_set_mesh_channel’:
net/wireless/./trace.h:943:1510: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_set_monitor_channel’:
net/wireless/./trace.h:961:765: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:961:765: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:961:765: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:961:765: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:961:765: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_auth’:
net/wireless/./trace.h:977:2089: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_assoc’:
net/wireless/./trace.h:1001:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_mgmt_tx_cancel_wait’:
net/wireless/./trace.h:1080:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1080:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_connect’:
net/wireless/./trace.h:1119:2673: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1119:2673: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1119:2673: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_set_cqm_rssi_config’:
net/wireless/./trace.h:1152:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_set_cqm_txe_config’:
net/wireless/./trace.h:1175:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1175:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1175:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_set_wiphy_params’:
net/wireless/./trace.h:1237:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_set_tx_power’:
net/wireless/./trace.h:1257:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1257:953: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_mgmt_frame_register’:
net/wireless/./trace.h:1338:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_return_int_tx_rx’:
net/wireless/./trace.h:1359:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1359:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_return_void_tx_rx’:
net/wireless/./trace.h:1378:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1378:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1378:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1378:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_tx_rx_evt’:
net/wireless/./trace.h:1401:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1401:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_return_int_survey_info’:
net/wireless/./trace.h:1492:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1492:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1492:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1492:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1492:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1492:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1492:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_tdls_oper’:
net/wireless/./trace.h:1529:2087: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_remain_on_channel’:
net/wireless/./trace.h:1597:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1597:933: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1597:933: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_return_int_cookie’:
net/wireless/./trace.h:1618:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_cancel_remain_on_channel’:
net/wireless/./trace.h:1635:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1635:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_mgmt_tx’:
net/wireless/./trace.h:1652:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1652:933: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1652:933: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_get_et_strings’:
net/wireless/./trace.h:1718:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_return_chandef’:
net/wireless/./trace.h:1740:936: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1740:936: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1740:936: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1740:936: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1740:936: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_set_mac_acl’:
net/wireless/./trace.h:1771:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_crit_proto_start’:
net/wireless/./trace.h:1809:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_rdev_crit_proto_stop’:
net/wireless/./trace.h:1829:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_send_rx_assoc’:
net/wireless/./trace.h:1897:1490: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_michael_mic_failure’:
net/wireless/./trace.h:1959:1503: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_ready_on_channel’:
net/wireless/./trace.h:1982:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1982:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1982:527: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:1982:527: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_ready_on_channel_expired’:
net/wireless/./trace.h:2004:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2004:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2004:527: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_new_sta’:
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2022:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_rx_mgmt’:
net/wireless/./trace.h:2045:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_mgmt_tx_status’:
net/wireless/./trace.h:2062:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2062:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_cqm_rssi_notify’:
net/wireless/./trace.h:2079:984: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_reg_can_beacon’:
net/wireless/./trace.h:2095:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2095:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2095:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2095:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2095:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_chandef_dfs_required’:
net/wireless/./trace.h:2110:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2110:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2110:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2110:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2110:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_ch_switch_notify’:
net/wireless/./trace.h:2125:930: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2125:930: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2125:930: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2125:930: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2125:930: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_radar_event’:
net/wireless/./trace.h:2141:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2141:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2141:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2141:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2141:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_cac_event’:
net/wireless/./trace.h:2156:937: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_probe_status’:
net/wireless/./trace.h:2200:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_cqm_pktloss_notify’:
net/wireless/./trace.h:2221:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_tdls_oper_request’:
net/wireless/./trace.h:2282:2087: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_scan_done’:
net/wireless/./trace.h:2305:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2305:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2305:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_get_bss’:
net/wireless/./trace.h:2345:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_inform_bss_frame’:
net/wireless/./trace.h:2372:767: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_bss_evt’:
net/wireless/./trace.h:2394:743: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_return_uint’:
net/wireless/./trace.h:2413:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_return_u32’:
net/wireless/./trace.h:2425:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
In file included from include/trace/ftrace.h:356:0,
                  from include/trace/define_trace.h:86,
                  from net/wireless/trace.h:2504,
                  from net/wireless/trace.c:5:
net/wireless/./trace.h: In function ‘ftrace_define_fields_cfg80211_report_wowlan_wakeup’:
net/wireless/./trace.h:2437:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
net/wireless/./trace.h:2437:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
