Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp103.mail.ukl.yahoo.com ([77.238.184.35]:23210 "HELO
	smtp103.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753674AbZGRVel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 17:34:41 -0400
Message-ID: <4A623E57.2030105@yahoo.co.uk>
Date: Sat, 18 Jul 2009 22:27:51 +0100
From: Rob <r0bjl@yahoo.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless-2.6.31-rc1 build problem
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hope this is the correct place to report it.  I can't build the above
with 2.6.27.23-0.1-default, gcc v4.3.2, openSUSE 11.1.
compat-wireless-2.6.30 is ok however.

  CC [M]  /compat-wireless-2.6.31-rc1/net/mac80211/main.o
/compat-wireless-2.6.31-rc1/net/mac80211/main.c: In function
‘ieee80211_bss_info_change_notify’:
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:293: warning:
‘beacon_int’ is deprecated (declared at
/compat-wireless-2.6.31-rc1/include/net/mac80211.h:593)
/compat-wireless-2.6.31-rc1/net/mac80211/main.c: In function
‘ieee80211_alloc_hw’:
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:714: warning:
‘radio_enabled’ is deprecated (declared at
/compat-wireless-2.6.31-rc1/include/net/mac80211.h:599)
/compat-wireless-2.6.31-rc1/net/mac80211/main.c: At top level:
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:758: error: variable
‘ieee80211_master_ops’ has initializer but incomplete type
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:759: error: unknown
field ‘ndo_start_xmit’ specified in initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:759: warning: excess
elements in struct initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:759: warning: (near
initialization for ‘ieee80211_master_ops’)
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:760: error: unknown
field ‘ndo_open’ specified in initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:760: warning: excess
elements in struct initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:760: warning: (near
initialization for ‘ieee80211_master_ops’)
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:761: error: unknown
field ‘ndo_stop’ specified in initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:761: warning: excess
elements in struct initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:761: warning: (near
initialization for ‘ieee80211_master_ops’)
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:762: error: unknown
field ‘ndo_set_multicast_list’ specified in initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:762: warning: excess
elements in struct initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:762: warning: (near
initialization for ‘ieee80211_master_ops’)
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:763: error: unknown
field ‘ndo_select_queue’ specified in initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:763: warning: excess
elements in struct initializer
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:763: warning: (near
initialization for ‘ieee80211_master_ops’)
/compat-wireless-2.6.31-rc1/net/mac80211/main.c: In function
‘ieee80211_master_setup’:
/compat-wireless-2.6.31-rc1/net/mac80211/main.c:769: error: ‘struct
net_device’ has no member named ‘netdev_ops’
make[5]: *** [/compat-wireless-2.6.31-rc1/net/mac80211/main.o] Error 1
make[4]: *** [/compat-wireless-2.6.31-rc1/net/mac80211] Error 2
make[3]: *** [_module_/compat-wireless-2.6.31-rc1] Error 2
make[2]: *** [sub-make] Error 2
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.27.23-0.1-obj/i386/default'
make: *** [modules] Error 2
