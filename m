Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32782 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0AZH2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 02:28:38 -0500
Message-ID: <20100126022837.t3t01o2w0gow8sow-cebfxv@webmail.spamcop.net>
Date: Tue, 26 Jan 2010 02:28:37 -0500
From: Pavel Roskin <proski@gnu.org>
To: PAN Sunny S K <sunnypan@ust.hk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for
	PowerPC architecture
References: In-Reply-To:
	<51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
In-Reply-To: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting PAN Sunny S K <sunnypan@ust.hk>:

> Our application deployment on other device are
> currently based on 802.11abg Atheros card with Madwifi driver. Starting
> with this MPC8377EWLAN, we would like to trial with a new Atheros AR9160
> 802.11bgn card. Since the chipset is not supported by Madwifi

Please check your facts.  MadWifi trunk supports AR9160 just fine,  
albeit without 802.11n support.  If it doesn't work for you, please  
report it to the MadWifi mailing list.

> The MPC8377EWLAN is using a PowerPC architecture MPC8377 CPU and the
> firmware is built by using Freescale's LTIB, the kernel came with the LTIB
> is 2.6.25 which is slightly different from the mainstream 2.6.25 kernel.
> However, when I try to integrate the compat-wireless-old source into the
> LTIB's 2.6.25 kernel, error comes up in socket.c and many other networking
> source.

Reports about errors without exact error messages are useless most of  
the time.  One error message should be enough.

> Therefore, I'd like to seek for some advice of whether the
> compat-wireless-old could be compiled with linux kernels that is compiled
> with BSP like LTIB. And how can I solve the building problem between the
> compat-wireless-old and the 2.6.25 kernel?

You didn't describe the problem enough for somebody else to reproduce  
it and identify it as being the same problem as the one you are  
experiencing.

-- 
Regards,
Pavel Roskin
