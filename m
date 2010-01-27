Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51406.mail.re2.yahoo.com ([206.190.38.185]:44154 "HELO
	web51406.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754842Ab0A0ORy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 09:17:54 -0500
Message-ID: <868377.1443.qm@web51406.mail.re2.yahoo.com>
Date: Wed, 27 Jan 2010 06:17:53 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: mac80211: Open bug in current wireless-testing
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
some time ago I reported that it is currently impossible to change a manually selected data rate back to the automatic rate selection. This bug is still present and is easy to reproduce:

iwconfig wlan0 rate 54M
iwconfig wlan0 rate auto

I know that the wireless extensions are deprecated, but until iw supports manual rate selection, iwconfig is what I have to use.

-- 
Regards
       Joerg

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
