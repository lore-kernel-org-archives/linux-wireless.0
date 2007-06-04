Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51407.mail.re2.yahoo.com ([206.190.38.186]:35740 "HELO
	web51407.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752280AbXFDKiC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 06:38:02 -0400
Date: Mon, 4 Jun 2007 03:38:00 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Drivers that do not honor regulatory restrictions
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <749677.48211.qm@web51407.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I work for a company that has legal permission (from the local FCC equivalent) to use channels outside those licensed for normal 802.11 operations. For an existing product we consider moving to an embedded Linux design.

What mac80211 driver/firmware combinations do not enforce the regulatory channel restrictions? I tried to switch to channel 14 with bcm43xx-mac80211 (ieee80211_regdom was set to 64, e.g. Japan) and failed. So in this case this was probably the firmware interfering for my own good.
 -- 
 
Regards
 
       Joerg
 






      __________________________________  Yahoo! Clever: Stellen Sie Fragen und finden Sie Antworten. Teilen Sie Ihr Wissen. www.yahoo.de/clever

