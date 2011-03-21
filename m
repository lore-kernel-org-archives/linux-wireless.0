Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:43574 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1CUCEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 22:04:21 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2L24KML027904
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 22:04:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 4E1721E0426
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 22:04:19 -0400 (EDT)
Message-ID: <4D86B222.4070708@lockie.ca>
Date: Sun, 20 Mar 2011 22:04:18 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: kernel-2.6.36.2 works, later doesn't
References: <4D866BD1.9060904@lockie.ca>
In-Reply-To: <4D866BD1.9060904@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/11 17:04, James wrote:
> $ dmesg | grep phy
> BIOS-provided physical RAM map:
> modified physical RAM map:
> phy0: Selected rate control algorithm 'ath9k_rate_control'
> Registered led device: ath9k-phy0::radio
> Registered led device: ath9k-phy0::assoc
> Registered led device: ath9k-phy0::tx
> Registered led device: ath9k-phy0::rx
> phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
> mem=0xffffc90001900000, irq=17
>
> This is kernel-2.6.36.2.
> The wireless doesn't work on any later kernel that I have tried.
> It is very interesting the IRQ is 17 on this kernel but 18 on 2.6.37.3.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
I tried
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/compat-wireless-2.6.36-4.tar.bz2
but it doesn't work in the 2.6.36.2 kernel or the 2.6.38 kernel.

Where can I get the compat-wireless that is the exact code that is in
the 2.6.36.2 kernel and then I can try it in the 2.6.38 kernel?
