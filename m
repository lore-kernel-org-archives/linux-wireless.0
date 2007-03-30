Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51402.mail.re2.yahoo.com ([206.190.38.181]:47209 "HELO
	web51402.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945950AbXC3Ioc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2007 04:44:32 -0400
Date: Fri, 30 Mar 2007 01:37:51 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: mac80211 vs. hostapd
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <347198.46462.qm@web51402.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
can somebody explain the relationship between hostapd and mac80211? To =
be more specific:

I'm used to the Madwifi driver where one could create a virtual interfa=
ce in AP mode and the net80211
stack included in Madwifi would then provide the AP functionality.
I understand that things are differently with mac80211 based drivers. T=
he kernel part of the stack does
not include the AP functionality at all. Handling of associated station=
s is done by hostapd. Is this
correct so far? Does "iwconfig wlan0 mode master" have any meaning? How=
 does one create multiple
virtual interfaces (the equivalent of Madwifis wlanconfig command)?

If so, I could not find a sample configuration for hostapd that provide=
s a simple, unsecured AP.
I suspect that this is because traditionally hostapd has only been used=
 to provide a WPA secured AP.

Is this the right list to ask for such a sample configuration?
=20
--=20

Thanks in advance and kind regards

       Joerg








=09
	=09
___________________________________________________________=20
Der fr=FChe Vogel f=E4ngt den Wurm. Hier gelangen Sie zum neuen Yahoo! =
Mail: http://mail.yahoo.de
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
