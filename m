Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44881 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab1HNKqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:46:32 -0400
Received: by vws1 with SMTP id 1so3378012vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:46:31 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 14 Aug 2011 14:46:31 +0400
Message-ID: <CAL5UyxpC40VyXstqneP2MZFUTni6C2WBWsGHBYL=CZfJt5Fd2g@mail.gmail.com> (sfid-20110814_124641_051820_4D72C8BF)
Subject: carl9170 AP mode stops working in 3.0.x
From: Vladimir Menshakov <vladimir.menshakov@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good day!
I've been using TL-WN821Nv2 dongle as AP for a year or so. I'm using
linux x86_64 desktop + hostapd. After upgrading to linux
3.0/compat-wireless-3.0-1/2, my AP started freezing after a while
(Maybe several minutes or so).
What I've tried so far:
1) switching hostapd in b/g mode.
2) checked /sys/.../power/autosuspend and various power-saving
features. (Seems to be unsupported by my device anyway)
3) upgrading to firmware-1.9.4 + latest compat-wireless version.

Sometimes restarting hostapd helps, sometimes not. I don't see any
relevant error messages or something suspicious in logs. (Tried
raising hostapd logs to maximum verbosity)
The last good configuration was 2.6.39-r3 + compat-wireless-stable-39.1

How could I help you find/debug this problem? I saw other complaint on
the mail list and I guess it's similar issue.
