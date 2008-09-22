Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:30189 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbYIVTWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 15:22:25 -0400
Message-ID: <48C2B90652754533BE59C0FF46601C50@soleil> (sfid-20080922_212228_881727_338A3BBF)
From: "Philippe Waroquiers" <philippe.waroquiers@skynet.be>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
References: <CB9B2237C21D46F3B852E45F75E91C52@soleil> <43e72e890809221142i44c8e81apce14c6856a1e87d9@mail.gmail.com>
Subject: Re: prism54 stopped working after upgrade from kernel 2.6.25.14-69.fc8 to 2.6.26.3-14.fc8
Date: Mon, 22 Sep 2008 21:22:20 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Are you using prism54 or p54 in each kernel?
> 
> lsmod | egrep "p54|prism54"

p54pci and p54common are found in both kernel
no modules matching prism54

In fact, a few months ago, after a kernel upgrade, I had to blacklist prism54.
(prism54 is still in the blacklist).

Philippe

