Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35636 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbbCOCKI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 22:10:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YWy0C-0000oL-FT
	for linux-wireless@vger.kernel.org; Sun, 15 Mar 2015 03:10:04 +0100
Received: from 177.52-243-81.adsl-dyn.isp.belgacom.be ([81.243.52.177])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2015 03:10:04 +0100
Received: from koen.bulcke by 177.52-243-81.adsl-dyn.isp.belgacom.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2015 03:10:04 +0100
To: linux-wireless@vger.kernel.org
From: Koen Bulcke <koen.bulcke@gmail.com>
Subject: Re: Broadcom 43340
Date: Sun, 15 Mar 2015 02:03:59 +0000 (UTC)
Message-ID: <loom.20150315T024445-345@post.gmane.org> (sfid-20150315_031021_404495_E48E6039)
References: <550482A2.3080803@gmail.com> <55048833.90408@broadcom.com> <55048BB1.9080906@gmail.com> <550491DA.6030105@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Finally I got some progress thanks to your comment, 
I can now see the Wifi
networks on my Asus X205TA (kernel 4.0RC3). 
However, connecting to any
network seems still to be an issue:

vempc:~$ sudo wpa_supplicant -Dwext -iwlan0 -cwpa.conf
[sudo] password 
Successfully initialized wpa_supplicant
ioctl[SIOCSIWENCODEEXT]: Invalid argument
ioctl[SIOCSIWENCODEEXT]: Invalid argument
ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
wlan0: Trying to associate with a1:b1:e9:da:fd:75 
(SSID='WiFiD85' freq=2472 MHz)
ioctl[SIOCSIWFREQ]: Operation not supported
wlan0: Association request to the driver failed
wlan0: Authentication with a1:b1:e9:da:fd:75 timed out.
wlan0: CTRL-EVENT-DISCONNECTED 
bssid=a1:b1:e9:da:fd:75 reason=3
locally_generated=1
ioctl[SIOCSIWSCAN]: Invalid exchange


Thanks,
Koen.


