Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51032 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761210Ab0GUSRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 14:17:09 -0400
Received: by qwh6 with SMTP id 6so2602054qwh.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 11:17:08 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andreamrl@tiscali.it>
Subject: Master mode in rtl8187
Date: Wed, 21 Jul 2010 14:17:03 -0400
Message-ID: <87vd88n1i8.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey all,

I recently purchased a Netgear WG111v2 (based on rtl8187b) and after
seeing scattered reports[1] that master mode may be supported by the
rtl8187 driver. Unfortunately, hostapd throws up when it attempts to put
the card into master mode. Is master mode supported by this driver? I've
tried both 2.6.34 as well as the latest wireless-testing tree and
neither seem to work.

I noticed there was a patch[2] sent out a few years back, but it seems
no one followed up. While I don't have much experience working with
wireless hardware I've done kernel driver work before, so with some
guidance I might be able to finish up that patch. Any input would be
greatly appreciated. Thanks!

- Ben


[1] http://osdir.com/ml/linux.kernel.wireless.general/2007-07/msg00289.html
[2] http://osdir.com/ml/linux.kernel.wireless.general/2007-06/msg00455.html
