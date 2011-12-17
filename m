Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:53019 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751495Ab1LQJfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 04:35:55 -0500
Received: by lahl5 with SMTP id l5so3120630lah.27
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 01:35:52 -0800 (PST)
Subject: Re: wl0084a / wl1271 understanding
From: Luciano Coelho <coelho@ti.com>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAFU7RzPF7NKRkY70Vp_b55AUeDip+ePxk=zqJ_K=SsXUfse7Jw@mail.gmail.com>
References: <CAFU7RzPF7NKRkY70Vp_b55AUeDip+ePxk=zqJ_K=SsXUfse7Jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Dec 2011 11:35:47 +0200
Message-ID: <1324114547.2800.234.camel@cumari> (sfid-20111217_103600_375852_CAA10628)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Raffaele,

On Sat, 2011-12-17 at 05:54 +0100, Raffaele Recalcati wrote: 
> I'm an embedded developer and I really want opensource development for
> wireless, to be sure to maintain it in many kernel versions I will
> have.
> I'm not an wifi expert and so I can have done some mistakes here below.
> 
> wl1271
> =============
> At the end of
> http://processors.wiki.ti.com/index.php/ARM_Processor_Open_Source_Wireless_Connectivity
> http://www.openlink.org/software/linux-kernel#lk
> It seems the same as what I can find in drivers/net/wireless/wl12xx
> kernel directory.

Yes, we have full support for the wl1271 chip in the mainline kernel.
We are working actively on maintaining and improving it directly
upstream.  TI makes official releases to the customers which are based
on the upstream kernel.

Join us on IRC @Freenode #wl12xx to talk more about it if you like.


-- 
Cheers,
Luca.

