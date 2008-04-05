Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:37716 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYDET1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 15:27:54 -0400
Date: Sat, 5 Apr 2008 21:27:51 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: iwl965 in kernel 2.6.25-rc8
Message-ID: <20080405192751.GA12738@ics.muni.cz> (sfid-20080405_202800_340429_D087A73A)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I noticed some troubles with associating with AP. Am I supposed to do
something like this:
iwconfig wlan0 essid my_essid
ifconfig wlan0 up
iwconfig wlan0 essid my_essid

after the third command, I am associated with AP with ESSID my_essid.
If I omit any of the three commands, I cannot associate - the card repo=
rts not
associated.

--=20
Luk=E1=B9 Hejtm=E1nek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
