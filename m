Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep12-int.chello.at ([62.179.121.32]:56281 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759794Ab0COIIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 04:08:34 -0400
Message-ID: <4B9DEAF9.4020002@dp.fce.vutbr.cz>
Date: Mon, 15 Mar 2010 09:08:25 +0100
From: Jan Martinek <honza@dp.fce.vutbr.cz>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ISL3890, master mode, prism54 -> p54pci regression
References: <4B9B43B0.1030801@dp.fce.vutbr.cz> <201003131126.57729.chunkeey@googlemail.com>
In-Reply-To: <201003131126.57729.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

thank you very much to both of you for your answer. The reference to 
hostapd really helped me and now everything works fine. I set WPA2 with 
CCMP.

Well, there is one surprise. My computer, which serves as an Access 
Point used to be very stable. But since yesterday evening, when I got 
hostapd working the uptime is only several minutes, then it freezes.

It strongly depends on client's activity. Heavy internet traffic through 
WiFi makes my computer freeze. For example, if client (windows machine) 
connects to my WiFi network and watches some online video, it is a sure 
way to freeze the Access Point in several seconds.

I did not find anything suspicious in dmesg nor /var/log/messages.

This is my card:

03:06.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)

It is Z-Com XG-901 (Full-MAC, I think).

Does anyone else encountered freezing problems under heavy internet load?

Thank you,
Jan Martinek
