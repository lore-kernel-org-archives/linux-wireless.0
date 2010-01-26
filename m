Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.ust.hk ([143.89.13.11]:64632 "EHLO mx3.ust.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0AZHAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 02:00:50 -0500
Received: from sqmail.ust.hk (sqmail2.ust.hk [143.89.15.95])
	by mx3.ust.hk (8.13.8/8.13.8) with ESMTP id o0Q6iXOB088085
	for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 14:44:34 +0800 (HKT)
Message-ID: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
Date: Tue, 26 Jan 2010 14:44:34 +0800 (HKT)
Subject: Building of compat-wireless-old in 2.6.25 BSP kernel for PowerPC   
        architecture
From: "PAN Sunny S K" <sunnypan@ust.hk>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
References: In-Reply-To: 
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Sir,

My name is Sunny, I'm from the MTrec group in Hong Kong University of
Science and Technology. We are currently developing a network device which
will utilize the wireless technology. As part of the development, we are
examining different reference design from various companies. Currently
we've received a MPC8377EWLAN from Freescale which we will need to port
our application onto. Our application deployment on other device are
currently based on 802.11abg Atheros card with Madwifi driver. Starting
with this MPC8377EWLAN, we would like to trial with a new Atheros AR9160
802.11bgn card. Since the chipset is not supported by Madwifi, and the
driver provided by Freescale is proprietary and has problem with
wlanconfig list scan result, we try to build our own driver instead of
relying on Freescale.
The MPC8377EWLAN is using a PowerPC architecture MPC8377 CPU and the
firmware is built by using Freescale's LTIB, the kernel came with the LTIB
is 2.6.25 which is slightly different from the mainstream 2.6.25 kernel.
However, when I try to integrate the compat-wireless-old source into the
LTIB's 2.6.25 kernel, error comes up in socket.c and many other networking
source.
Therefore, I'd like to seek for some advice of whether the
compat-wireless-old could be compiled with linux kernels that is compiled
with BSP like LTIB. And how can I solve the building problem between the
compat-wireless-old and the 2.6.25 kernel?

Thanks in advance.

Best regards,
Sunny Pan

