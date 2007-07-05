Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51408.mail.re2.yahoo.com ([206.190.38.187]:46523 "HELO
	web51408.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758289AbXGEKgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 06:36:17 -0400
Date: Thu, 5 Jul 2007 03:36:16 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: 32 character ESSID broken with WE-21
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <111303.71455.qm@web51408.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
for some time there was an open bug in Madwifi related to 32 charater ESSIDs.
Doing some investigations I found that the same bug is present with an ipw2200bg
WLAN interface and Linux 2.6.20 (I tried the Ubuntu-7.0.4 CD).

Please try
iwconfig wlan0 essid 12345678901234567890123456789012
vs
iwconfig wlan0 essid 1234567890123456789012345678901

Using 32 character ESSIDs was fine with 2.6.18 (the last version I tested).
 
--  
Regards
 
       Joerg
 
See http://news.gmane.org/gmane.linux.drivers.madwifi.devel for the Madwifi bug report
See http://madwifi.org/ticket/930 for the Madwifi bug ticket







      __________________________________  Alles was der Gesundheit und Entspannung dient. BE A BETTER MEDIZINMANN! www.yahoo.de/clever
