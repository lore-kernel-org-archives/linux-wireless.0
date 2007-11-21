Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:3172 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXKUTfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 14:35:47 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2895445wah
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2007 11:35:46 -0800 (PST)
Message-ID: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com> (sfid-20071121_193550_720363_FAED080D)
Date: Wed, 21 Nov 2007 13:35:46 -0600
From: "John H." <mistamaila@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: timeout problems with certain APs and b43
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	"Larry Finger" <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 uname -a
Linux laptop 2.6.23.1-49.fc8 #1 SMP Thu Nov 8 21:41:26 EST 2007 i686
i686 i386 GNU/Linux
fedora 8

on certain APs, the internet works for a long time then stops, and I
get authentication time outs, why?  It usually works again if I reset
the AP itself, which i should not have to do and don't have to if in
XP....


wlan0: switched to long barker preamble (BSSID=00:0f:66:53:3e:24)
wlan0: switched to short barker preamble (BSSID=00:0f:66:53:3e:24)



wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:0f:66:53:3e:24
wlan0: authenticate with AP 00:0f:66:53:3e:24
wlan0: authenticate with AP 00:0f:66:53:3e:24
wlan0: authentication with AP 00:0f:66:53:3e:24 timed out
