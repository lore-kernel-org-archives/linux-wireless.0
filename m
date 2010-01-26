Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55301.mail.re4.yahoo.com ([206.190.58.180]:32216 "HELO
	web55301.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754675Ab0AZQbj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 11:31:39 -0500
Message-ID: <796923.61885.qm@web55301.mail.re4.yahoo.com>
Date: Tue, 26 Jan 2010 08:31:38 -0800 (PST)
From: X Xiao <austinxxh-linux@yahoo.com>
Reply-To: austinxxh-linux@yahoo.com
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for PowerPC           architecture
To: linux-wireless@vger.kernel.org, PAN Sunny S K <sunnypan@ust.hk>
In-Reply-To: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would recommend you upgrade your kernel to a newer version, where compat-wireless works better with. 83xx is well supported by newer kernels.
xxiao

--- On Tue, 1/26/10, PAN Sunny S K <sunnypan@ust.hk> wrote:

> From: PAN Sunny S K <sunnypan@ust.hk>
> Subject: Building of compat-wireless-old in 2.6.25 BSP kernel for PowerPC           architecture
> To: linux-wireless@vger.kernel.org
> Date: Tuesday, January 26, 2010, 12:44 AM
> Dear Sir,
> 
> My name is Sunny, I'm from the MTrec group in Hong Kong
> University of
> Science and Technology. We are currently developing a
> network device which
> will utilize the wireless technology. As part of the
> development, we are
> examining different reference design from various
> companies. Currently
> we've received a MPC8377EWLAN from Freescale which we will
> need to port
> our application onto. Our application deployment on other
> device are
> currently based on 802.11abg Atheros card with Madwifi
> driver. Starting
> with this MPC8377EWLAN, we would like to trial with a new
> Atheros AR9160
> 802.11bgn card. Since the chipset is not supported by
> Madwifi, and the
> driver provided by Freescale is proprietary and has problem
> with
> wlanconfig list scan result, we try to build our own driver
> instead of
> relying on Freescale.
> The MPC8377EWLAN is using a PowerPC architecture MPC8377
> CPU and the
> firmware is built by using Freescale's LTIB, the kernel
> came with the LTIB
> is 2.6.25 which is slightly different from the mainstream
> 2.6.25 kernel.
> However, when I try to integrate the compat-wireless-old
> source into the
> LTIB's 2.6.25 kernel, error comes up in socket.c and many
> other networking
> source.
> Therefore, I'd like to seek for some advice of whether the
> compat-wireless-old could be compiled with linux kernels
> that is compiled
> with BSP like LTIB. And how can I solve the building
> problem between the
> compat-wireless-old and the 2.6.25 kernel?
> 
> Thanks in advance.
> 
> Best regards,
> Sunny Pan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
