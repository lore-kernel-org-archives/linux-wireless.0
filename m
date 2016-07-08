Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15151 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbcGHOcl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 10:32:41 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Prasun Maiti <prasunmaiti87@gmail.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] mwifiex: Reduce endian conversion for REG Host
 Commands
Date: Fri, 8 Jul 2016 14:32:31 +0000
Message-ID: <edd221ee06dd4f9c8ecec45de67de35b@SC-EXCH04.marvell.com> (sfid-20160708_163301_511310_A50D2E1E)
References: <39f33dff10344e53b0fbbc9681f90b33@SC-EXCH04.marvell.com>
	<1467022402-23990-1-git-send-email-prasunmaiti87@gmail.com>
	<8e1cc4765b4242a4a48f86abddbe40fc@SC-EXCH04.marvell.com>
 <877fcw1c51.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877fcw1c51.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Kalle Valo
> Sent: Friday, July 08, 2016 7:10 PM
> To: Amitkumar Karwar
> Cc: Prasun Maiti; Nishant Sarmukadam; Linux Wireless; Linux Next; Linux
> Kernel
> Subject: Re: [PATCH v4] mwifiex: Reduce endian conversion for REG Host
> Commands
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> >> From: Prasun Maiti [mailto:prasunmaiti87@gmail.com]
> >> Sent: Monday, June 27, 2016 3:43 PM
> >> To: Amitkumar Karwar
> >> Cc: Nishant Sarmukadam; Linux Wireless; Linux Next; Linux Kernel;
> >> Kalle Valo
> >> Subject: [PATCH v4] mwifiex: Reduce endian conversion for REG Host
> >> Commands
> >>
> >> For multiple REG Host Commands (e.g HostCmd_CMD_802_11_EEPROM_ACCESS,
> >> HostCmd_CMD_MAC_REG_ACCESS etc.) "cpu_to_leX"-converted values are
> >> saved to driver. So, "leX_to_cpu" conversion is required too many
> >> times afterwards in driver.
> >>
> >> This patch reduces the endian: conversion without saving "cpu_to_leX"
> >> converted values in driver. This will convert endianness in prepare
> >> command and command response path.
> >>
> >> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
> 
> [deleted almost 300 lines of unnecessary quotes]
> 
> > Any specific reason for dropping this patch?
> > I can see the status as "Deferred" on patchwork.
> 
> It's not dropped, "Deferred" means that the patch was postponed for some
> reason and I need to look at the patch more carefully. In this case I
> did it because I was hoping to see an Acked-by from you.

Thanks for clarification. I will ack the patch.

Regards,
Amitkumar
