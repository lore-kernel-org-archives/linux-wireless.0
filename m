Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45129 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZDCQgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 12:36:18 -0400
Received: by bwz17 with SMTP id 17so1044401bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 09:36:14 -0700 (PDT)
Message-ID: <49D63AF5.4080302@gmail.com> (sfid-20090403_183622_788837_CE736EE9)
Date: Fri, 03 Apr 2009 18:36:05 +0200
From: Witold Sowa <witold.sowa@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: GSoC proposal - AP mode for NetworkManager
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have just sent my proposal to Google Summer of Code project: AP mode
support for NetworkManager.
You can read it here:
http://student.agh.edu.pl/~wsowa/gsoc.txt

Since, I haven't received reply form Dan Williams, I will allow myself
to take the liberty of quoting below the mail I sent him. It contains
general description of my idea and some questions. Request for comments :-)

Thanks,
Witold Sowa

"Hi,

I am interested in realization of 'Add AP support to Network Manager'
Google Summer of Code project witch you are mentoring and I'd like to
discuss my ideas and ask some questions.

First of all, you wrote on
http://wireless.kernel.org/en/developers/GSoC/2009/Add_AP_Support_to_Network_Manager
that hostapd functionality will be incorporated into wpa_supplicant
soon. Actually, I couldn't find any information about it, so here is the
basic question: Does wpa_supplicant incorporate AP functionality or when
will it do?

I went through a few docs, mailing lists and cursorily through source
codes of hostapd and NetworkManager before I found your note about
incorporating AP into wpa_supplicant. That's why I developed a general
idea of realization the project using hostapd:

1. hostapd should be modified in such a way that it could be configured
via dbus just like wpa_supplicant can be. This would require creating a
dbus interface and moving most of configuration options from config file
to the dbus interface. This will probably turn most of hostapd's code
upside down, and this would be probably the most difficult and time
consuming part.

2. hostapd should be started and kept alive by NetworkManager just like
wpa_supplicant is now (using some dbus service - I'm not sure how it
works for wpa_supplicant and NM now). NM should then use hostapd's dbus
interface to communicate with it.

3. Some additional dbus interfaces should be added to NM, which will
allow client applications like nm-applet, knetworkmanager, etc. set
wireless interface in AP (master) mode and configure it.

4. Fancy GUI controls would be added to nm-applet which will let user to
set his own AP "with 2 simple mouse clicks ;-)".

As you can see first two points seem to boil down to making hostapd
usage simmilar to wpa_supplicant so it could be a good idea to move
hostapd functionality to wpa_supplicant instead - if it hasn't already
been done. In case it has been done, I could focus only on points 3 and 4.

I will be grateful if you tell me what is your opinion about my
approach, what should I take notice of and what is state of
incorporating hostapd into wpa_supplicant. I will appreciate any
suggestions or advice too.

Regards,
Witold Sowa"

