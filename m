Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway01.websitewelcome.com ([67.18.65.19]:44417 "HELO
	gateway01.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753959AbYL0PNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 10:13:38 -0500
Received: from 96-26-251-53.sea.clearwire-dns.net ([96.26.251.53]:39932 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LGaki-0000fV-GH
	for linux-wireless@vger.kernel.org; Sat, 27 Dec 2008 09:06:56 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Setting 'n' or 'a' Mode, and WPA2?
Date: Sat, 27 Dec 2008 07:06:56 -0800
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812270706.56478.Info@delphi-real-estate.com> (sfid-20081227_161355_713404_4B664DF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I want to switch to 802.11a for streaming media, so I'm not polluting everyone else's bandwidth.  Does anyone know how I set the 4965 to 'a' or 'n' only?  Is there any way to set it to dual-band for the new routers which send normal traffic on 'g' and stream on 'a'?  How do I set it to WPA2 only?  

IOW, how do I control this card?  Instructions are nowhere to be found.

Currently my /etc/network/interfaces file is set thus and works (Network Manager is uninstalled and I don't trust it):
iface wlan0 inet static
pre-up /sbin/iwconfig wlan0 txpower 5
pre-up ip link set wlan0 up
address 192.168.1.1
netmask 255.255.255.0
gateway 192.168.1.5
wireless-essid Hex
wpa-scan-ssid 0
wpa-ap-scan 1
wpa-ssid Hex
wpa-psk Freeasinfreedom


