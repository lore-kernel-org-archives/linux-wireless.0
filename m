Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox1.netikka.net ([213.250.81.202]:44425 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0LPQzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 11:55:06 -0500
Message-ID: <4D0A4467.3000208@pcuf.fi>
Date: Thu, 16 Dec 2010 18:55:03 +0200
From: Jar <jar@pcuf.fi>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rt2400pci.ko and it's AES/WPA2 support [Not subscribed to the
 list]
References: <4D0A33E2.9090509@pcuf.fi> <AANLkTinxi_VrCeboC0j2T_oMtQxvYP_oAzmXXr4KNetA@mail.gmail.com>
In-Reply-To: <AANLkTinxi_VrCeboC0j2T_oMtQxvYP_oAzmXXr4KNetA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16.12.2010 18:42, Ivo Van Doorn wrote:
> Yes, it does support it. It is all software encryption though, since there
> is no hardware acceleration possible with this hardware.

Thanks a lot!!!! Now I only have to find reason why Lubuntu wants to use 
TKIP and not AES, even when the access point advertises AES (and TKIP) 
capability in the scan results.

-- 
Best Regards, Jar
