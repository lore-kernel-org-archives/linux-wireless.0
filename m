Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:39052 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2BVOXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 09:23:42 -0500
Received: by qafk1 with SMTP id k1so217357qaf.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 06:23:42 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 22 Feb 2012 15:23:41 +0100
Message-ID: <CAFED-j=pt4zyuWP9g6rhjzDDwxmrw01w1Lek=k5i7rzekezpAA@mail.gmail.com> (sfid-20120222_152346_033605_A986F9A5)
Subject: compat-wireless-2012-02-21 compilation issue (2.6.35-32)
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have compilation issue.
Is there any patch available?


jadz@uw000950:~/builds/community/compat-wireless-2012-02-21$ make
make -C /lib/modules/2.6.35-32-generic/build
M=/home/xpujadz/builds/community/compat-wireless-2012-02-21 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.35-32-generic'
  Building modules, stage 2.
  MODPOST 9 modules
WARNING: "__tracepoint_drv_return_void"
[/home/xpujadz/builds/community/compat-wireless-2012-02-21/net/mac80211/mac80211.ko]
undefined!
WARNING: "__tracepoint_drv_bss_info_changed"
[/home/xpujadz/builds/community/compat-wireless-2012-02-21/net/mac80211/mac80211.ko]
undefined!
WARNING: "__tracepoint_api_stop_tx_ba_session"
[/home/xpujadz/builds/community/compat-wireless-2012-02-21/net/mac80211/mac80211.ko]
undefined!
WARNING: "__tracepoint_drv_configure_filter"
[/home/xpujadz/builds/community/compat-wireless-2012-02-21/net/mac80211/mac80211.ko]
undefined!

uname:
Linux uw000950 2.6.35-32-generic #64~lucid1-Ubuntu SMP Tue Jan 3
15:41:36 UTC 2012 x86_64 GNU/Linux

BR
Janusz
