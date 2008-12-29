Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([67.18.80.17]:57334 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752321AbYL2NRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 08:17:44 -0500
Received: from 96-26-251-53.sea.clearwire-dns.net ([96.26.251.53]:48630 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LHHtd-0002NT-QN
	for linux-wireless@vger.kernel.org; Mon, 29 Dec 2008 07:11:02 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Setting 'n' or 'a' Mode, and WPA2?
Date: Mon, 29 Dec 2008 05:11:01 -0800
References: <200812270706.56478.Info@delphi-real-estate.com>
In-Reply-To: <200812270706.56478.Info@delphi-real-estate.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812290511.01527.Info@delphi-real-estate.com> (sfid-20081229_141748_202246_77C534AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Wow, surely this is not unknown by some of you guys.  Isn't anyone using 'a' mode or 5GHz 'n' mode?  WPA2?

Will you please advise?


On Saturday 27 December 2008 7:06:56 Delphi Real Estate wrote:
> 
> I want to switch to 802.11a for streaming media, so I'm not polluting everyone else's bandwidth.  Does anyone know how I set the 4965 to 'a' or 'n' only?  Is there any way to set it to dual-band for the new routers which send normal traffic on 'g' and stream on 'a'?  How do I set it to WPA2 only?  
> 
> IOW, how do I control this card?  Instructions are nowhere to be found.
> 
> Currently my /etc/network/interfaces file is set thus and works (Network Manager is uninstalled and I don't trust it):
> iface wlan0 inet static
> pre-up /sbin/iwconfig wlan0 txpower 5
> pre-up ip link set wlan0 up
> address 192.168.1.1
> netmask 255.255.255.0
> gateway 192.168.1.5
> wireless-essid Hex
> wpa-scan-ssid 0
> wpa-ap-scan 1
> wpa-ssid Hex
> wpa-psk Freeasinfreedom
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


