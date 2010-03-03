Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61403 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab0CCA5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 19:57:45 -0500
Received: by fxm19 with SMTP id 19so1015754fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 16:57:44 -0800 (PST)
Subject: Athros wireless stopped working
From: Jim Ham <jimham@dslextreme.com>
Reply-To: Jimham@porcine.com
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 16:57:28 -0800
Message-ID: <1267577848.19553.12.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The athros chip in my Fujitsu notebook as stopped working after an
update  (Debian squeeze) about a month ago. It uses the ath5k driver.
uname -a returns Linux WideBook 2.6.32-trunk-amd64 #1 SMP Sun Jan 10
22:40:40 UTC 2010 x86_64 GNU/Linux

It appears that iwconfig can't set the essid and the password reliably.
When I issue iwconfig ath0 I usually get garbage in the essid and
password fields. This can be after setting both (with iwconfig)
apparently successfully.

This notebook is dual boot so I know that the hardware is working. 

I have put some debug output in the wireless-tools script in if-pre-up.d
so that I can see that the essid and password fields seem to 'take' for
a short time, then revert to garbage.

Does any of this sound familiar? Is this a known problem?

Regards,

Jim Ham


