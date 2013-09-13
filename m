Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57021 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249Ab3IMOYW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 10:24:22 -0400
Received: from [192.168.2.102] ([93.218.92.56]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0LsOsW-1W4rl53IJU-011w1g for
 <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 16:24:20 +0200
Message-ID: <5233200E.4010102@rempel-privat.de> (sfid-20130913_162426_005884_531E888F)
Date: Fri, 13 Sep 2013 16:24:14 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Prabhunath G <gprabhunath@gmail.com>
CC: linux-wireless@vger.kernel.org,
	kernelnewbies <kernelnewbies@kernelnewbies.org>
Subject: Re: WEP/WPA/WPA2 implementation in software
References: <CACPKTAM-mtTS7QVSq817TQ11dS-cLA+nKgXF6yDGYvxw9rhucw@mail.gmail.com>
In-Reply-To: <CACPKTAM-mtTS7QVSq817TQ11dS-cLA+nKgXF6yDGYvxw9rhucw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 13.09.2013 13:53, schrieb Prabhunath G:
> Dear All,
>
>           Suppose there is no hardware support for
> encryption/decryption for Wi-Fi devices. Will the data be
> encrypted/decrypted by software implementation. If yes, is it done at
> the application level or at the kernel level (mac80211).
> Kindly clarify.
> If the question has to be rephrased, please do it

Hi,

see hostapd on AP site and wpa_supplicant on STA:
http://wireless.kernel.org/en/users/Documentation/wpa_supplicant
http://wireless.kernel.org/en/users/Documentation/hostapd

check documentation here on:
http://wireless.kernel.org/en/users/Documentation
may be it will answer some of your questions.

-- 
Regards,
Oleksij
