Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userg506.nifty.com ([202.248.238.86]:32872 "EHLO
	userg506.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1LAJpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 04:45:39 -0500
Received: from [127.0.0.1] (nthkid058077.hkid.nt.ngn.ppp.infoweb.ne.jp [219.104.176.77])by userg506.nifty.com with ESMTP id pB19jRq9010670
	for <linux-wireless@vger.kernel.org>; Thu, 1 Dec 2011 18:45:32 +0900
Date: Thu, 01 Dec 2011 18:44:42 +0900
From: Masahiro Inoue <miyabi.-.inoue@nifty.com>
To: linux-wireless@vger.kernel.org
Subject: Build Error Report
Message-Id: <20111201184436.0F31.2E210E2F@nifty.com> (sfid-20111201_104544_620211_C49BC068)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The build error occurs by compat-wireless-2011-11-30.
My kernel is 2.6.27.

  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/main.o
In file included from /home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:6,
                 from /home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/main.c:28:
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:36: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:48: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:71: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:91: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:112: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:117: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:131: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:146: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:160: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:165: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:170: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:175: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:180: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:186: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:214: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:220: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:262: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:312: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:339: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:347: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:355: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:376: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:404: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:428: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:462: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:490: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:496: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:502: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:508: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:514: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:519: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:524: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:555: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:580: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:585: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:590: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:611: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:639: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:664: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:689: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:725: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:731: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:756: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:762: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:767: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:803: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:825: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:846: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:874: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:899: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:924: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:950: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:955: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:983: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1006: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1035: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1040: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1045: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1072: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1100: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1122: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1157: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1167: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1181: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1202: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1225: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1246: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1269: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1274: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1293: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1312: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1334: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1355: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1373: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1391: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1415: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1436: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1441: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1446: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1467: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1491: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1518: error: expected ')' before 'struct'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-trace.h:1542: error: expected ')' before 'struct'
In file included from /home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/main.c:28:
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_start':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:42: error: implicit declaration of function 'trace_drv_start'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:46: error: implicit declaration of function 'trace_drv_return_int'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_stop':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:54: error: implicit declaration of function 'trace_drv_stop'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:56: error: implicit declaration of function 'trace_drv_return_void'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_suspend':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:75: error: implicit declaration of function 'trace_drv_suspend'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_resume':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:87: error: implicit declaration of function 'trace_drv_resume'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_add_interface':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:105: error: implicit declaration of function 'trace_drv_add_interface'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_change_interface':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:125: error: implicit declaration of function 'trace_drv_change_interface'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_remove_interface':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:138: error: implicit declaration of function 'trace_drv_remove_interface'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_config':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:150: error: implicit declaration of function 'trace_drv_config'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_bss_info_changed':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:165: error: implicit declaration of function 'trace_drv_bss_info_changed'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_tx_sync':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:182: error: implicit declaration of function 'trace_drv_tx_sync'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_finish_tx_sync':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:199: error: implicit declaration of function 'trace_drv_finish_tx_sync'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_prepare_multicast':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:219: error: implicit declaration of function 'trace_drv_prepare_multicast'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:230: error: implicit declaration of function 'trace_drv_return_u64'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_configure_filter':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:242: error: implicit declaration of function 'trace_drv_configure_filter'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_tim':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:253: error: implicit declaration of function 'trace_drv_set_tim'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_key':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:272: error: implicit declaration of function 'trace_drv_set_key'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_update_tkip_key':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:291: error: implicit declaration of function 'trace_drv_update_tkip_key'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_hw_scan':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:308: error: implicit declaration of function 'trace_drv_hw_scan'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_cancel_hw_scan':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:321: error: implicit declaration of function 'trace_drv_cancel_hw_scan'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_sched_scan_start':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:338: error: implicit declaration of function 'trace_drv_sched_scan_start'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_sched_scan_stop':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:352: error: implicit declaration of function 'trace_drv_sched_scan_stop'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_sw_scan_start':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:361: error: implicit declaration of function 'trace_drv_sw_scan_start'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_sw_scan_complete':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:371: error: implicit declaration of function 'trace_drv_sw_scan_complete'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_get_stats':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:386: error: implicit declaration of function 'trace_drv_get_stats'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_get_tkip_seq':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:396: error: implicit declaration of function 'trace_drv_get_tkip_seq'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_frag_threshold':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:406: error: implicit declaration of function 'trace_drv_set_frag_threshold'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_rts_threshold':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:420: error: implicit declaration of function 'trace_drv_set_rts_threshold'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_coverage_class':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:433: error: implicit declaration of function 'trace_drv_set_coverage_class'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_sta_notify':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:451: error: implicit declaration of function 'trace_drv_sta_notify'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_sta_add':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:468: error: implicit declaration of function 'trace_drv_sta_add'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_sta_remove':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:486: error: implicit declaration of function 'trace_drv_sta_remove'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_conf_tx':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:503: error: implicit declaration of function 'trace_drv_conf_tx'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_get_tsf':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:520: error: implicit declaration of function 'trace_drv_get_tsf'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_tsf':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:535: error: implicit declaration of function 'trace_drv_set_tsf'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_reset_tsf':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:548: error: implicit declaration of function 'trace_drv_reset_tsf'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_tx_last_beacon':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:560: error: implicit declaration of function 'trace_drv_tx_last_beacon'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_ampdu_action':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:580: error: implicit declaration of function 'trace_drv_ampdu_action'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_get_survey':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:596: error: implicit declaration of function 'trace_drv_get_survey'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_flush':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:618: error: implicit declaration of function 'trace_drv_flush'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_channel_switch':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:629: error: implicit declaration of function 'trace_drv_channel_switch'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_antenna':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:642: error: implicit declaration of function 'trace_drv_set_antenna'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_get_antenna':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:653: error: implicit declaration of function 'trace_drv_get_antenna'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_remain_on_channel':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:666: error: implicit declaration of function 'trace_drv_remain_on_channel'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_cancel_remain_on_channel':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:680: error: implicit declaration of function 'trace_drv_cancel_remain_on_channel'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_ringparam':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:694: error: implicit declaration of function 'trace_drv_set_ringparam'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_get_ringparam':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:707: error: implicit declaration of function 'trace_drv_get_ringparam'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_tx_frames_pending':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:719: error: implicit declaration of function 'trace_drv_tx_frames_pending'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:722: error: implicit declaration of function 'trace_drv_return_bool'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_bitrate_mask':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:737: error: implicit declaration of function 'trace_drv_set_bitrate_mask'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_set_rekey_data':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:752: error: implicit declaration of function 'trace_drv_set_rekey_data'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_rssi_callback':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:761: error: implicit declaration of function 'trace_drv_rssi_callback'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_release_buffered_frames':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:773: error: implicit declaration of function 'trace_drv_release_buffered_frames'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h: In function 'drv_allow_buffered_frames':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/driver-ops.h:788: error: implicit declaration of function 'trace_drv_allow_buffered_frames'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/main.c: In function 'ieee80211_restart_hw':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/main.c:392: error: implicit declaration of function 'trace_api_restart_hw'
make[3]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211/main.o] Error 1
make[2]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30/net/mac80211] Error 2
make[1]: *** [_module_/home/miyabi/test/compat-wireless/compat-wireless-2011-11-30] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27-74vl5-x86_64'
make: *** [modules] Error 2


