Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:49000 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZHGUvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 16:51:20 -0400
Received: by pzk34 with SMTP id 34so1824821pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 13:51:21 -0700 (PDT)
Message-ID: <4A7C9383.2040705@lwfinger.net>
Date: Fri, 07 Aug 2009 15:50:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Deauthentications with p54usb
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

I've been working with b43 of late and had not run p54usb until I
tested the rfkill code earlier today. Now I'm getting
deauthentications with reason=7 that I did not get with b43 using the
same AP in roughly the same geometric relationship.

I don't know if this is a regression, or not. The current kernel is
2.6.31-rc5-wl. I'll boot 2.6.30-wl to test if the older one is OK.

The logged data below shows nothing but the timing of the disconnects.

Larry

============

Aug  7 15:28:33 larrylap kernel: wlan0: deauthenticated from
00:1a:70:46:ba:b1 (Reason: 7)
Aug  7 15:28:35 larrylap kernel: wlan0: direct probe to AP
00:1a:70:46:ba:b1 (try 1)
Aug  7 15:28:35 larrylap kernel: wlan0 direct probe responded
Aug  7 15:28:35 larrylap kernel: wlan0: authenticate with AP
00:1a:70:46:ba:b1 (try 1)
Aug  7 15:28:35 larrylap kernel: wlan0: authenticated
Aug  7 15:28:35 larrylap kernel: wlan0: associate with AP
00:1a:70:46:ba:b1 (try 1)
Aug  7 15:28:35 larrylap kernel: wlan0: RX AssocResp from
00:1a:70:46:ba:b1 (capab=0x431 status=0 aid=1)
Aug  7 15:28:35 larrylap kernel: wlan0: associated
Aug  7 15:29:59 larrylap kernel: wlan0: deauthenticated from
00:1a:70:46:ba:b1 (Reason: 7)
Aug  7 15:30:01 larrylap kernel: wlan0: direct probe to AP
00:1a:70:46:ba:b1 (try 1)
Aug  7 15:30:01 larrylap kernel: wlan0 direct probe responded
Aug  7 15:30:01 larrylap kernel: wlan0: authenticate with AP
00:1a:70:46:ba:b1 (try 1)
Aug  7 15:30:01 larrylap kernel: wlan0: authenticated
Aug  7 15:30:01 larrylap kernel: wlan0: associate with AP
00:1a:70:46:ba:b1 (try 1)
Aug  7 15:30:01 larrylap kernel: wlan0: RX AssocResp from
00:1a:70:46:ba:b1 (capab=0x431 status=0 aid=1)
Aug  7 15:30:01 larrylap kernel: wlan0: associated
