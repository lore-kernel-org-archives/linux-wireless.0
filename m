Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:50087 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab0ETU26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 16:28:58 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 May 2010 21:28:50 +0200
MIME-Version: 1.0
Subject: Re: How to scan APs with ATH5k?
CC: Bob Copeland <me@bobcopeland.com>
Message-ID: <4BF58D72.22852.D1D2D@jafojtik.seznam.cz>
In-reply-to: <AANLkTim90zZxvcwT9joVAqO1oDzk-jCaRCQAd0Cfu3N0@mail.gmail.com>
References: <1274296671-13596-1-git-send-email-gwingerde@gmail.com>, <4BF4CFE8.10182.FA668@jafojtik.seznam.cz>, <AANLkTim90zZxvcwT9joVAqO1oDzk-jCaRCQAd0Cfu3N0@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bob,

> $ sudo ifconfig wlan0 up
> $ sudo iw dev wlan0 scan

I have typed:

ifconfig wlan0 down
ifconfig wlan0 up
iwlist wlan0 scanning 
  (I do not have installed iw)

and it works:

wlan1     Scan completed :
          Cell 01 - Address: 00:15:6D:D6:2A:9D
                    Channel:36
                    Frequency:5.18 GHz (Channel 36)
                    Quality=38/70  Signal level=-72 dBm
                    Encryption key:off
                    ESSID:"dvrmn.heaven-czfree.net"
                    Bit Rate:6 Mb/s
                    Bit Rate:9 Mb/s
                    Bit Rate:12 Mb/s
                    Bit Rate:18 Mb/s
                    Bit Rate:24 Mb/s
                    Bit Rate:36 Mb/s
                    Bit Rate:48 Mb/s
                    Bit Rate:54 Mb/s
                    Mode:Master
                    Extra:tsf=000000949a880598
                    Extra: Last beacon: 1533ms ago
                    (Unknown Wireless Token 0x8C05)
          Cell 02 - Address: 00:19:E0:84:E1:4C
                    Channel:2
                    Frequency:2.417 GHz (Channel 2)
.............................................


But when an interface wlan0 become associated, it refuses scanning.

root@dvouramenna:~# iwlist wlan0 scanning
wlan0     Interface doesn't support scanning : Operation not supported


Is this bug or feature?

MadWifi can scan even when interface is associated.
ipw2200bg can also scan when it is associated.

regards
   J.Fojtik







> 
> -- 
> Bob Copeland %% www.bobcopeland.com


