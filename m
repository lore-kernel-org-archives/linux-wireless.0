Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56659 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbcGHNkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:40:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Prasun Maiti <prasunmaiti87@gmail.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] mwifiex: Reduce endian conversion for REG Host Commands
References: <39f33dff10344e53b0fbbc9681f90b33@SC-EXCH04.marvell.com>
	<1467022402-23990-1-git-send-email-prasunmaiti87@gmail.com>
	<8e1cc4765b4242a4a48f86abddbe40fc@SC-EXCH04.marvell.com>
Date: Fri, 08 Jul 2016 16:40:26 +0300
In-Reply-To: <8e1cc4765b4242a4a48f86abddbe40fc@SC-EXCH04.marvell.com>
	(Amitkumar Karwar's message of "Fri, 8 Jul 2016 11:02:45 +0000")
Message-ID: <877fcw1c51.fsf@kamboji.qca.qualcomm.com> (sfid-20160708_154056_040973_8BADE512)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> From: Prasun Maiti [mailto:prasunmaiti87@gmail.com]
>> Sent: Monday, June 27, 2016 3:43 PM
>> To: Amitkumar Karwar
>> Cc: Nishant Sarmukadam; Linux Wireless; Linux Next; Linux Kernel; Kalle
>> Valo
>> Subject: [PATCH v4] mwifiex: Reduce endian conversion for REG Host
>> Commands
>> 
>> For multiple REG Host Commands (e.g HostCmd_CMD_802_11_EEPROM_ACCESS,
>> HostCmd_CMD_MAC_REG_ACCESS etc.) "cpu_to_leX"-converted values are saved
>> to driver. So, "leX_to_cpu" conversion is required too many times
>> afterwards in driver.
>> 
>> This patch reduces the endian: conversion without saving "cpu_to_leX"
>> converted values in driver. This will convert endianness in prepare
>> command and command response path.
>> 
>> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>

[deleted almost 300 lines of unnecessary quotes]

> Any specific reason for dropping this patch?
> I can see the status as "Deferred" on patchwork.

It's not dropped, "Deferred" means that the patch was postponed for some
reason and I need to look at the patch more carefully. In this case I
did it because I was hoping to see an Acked-by from you.

-- 
Kalle Valo
