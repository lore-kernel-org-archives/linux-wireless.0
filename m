Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48048 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcFVLBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 07:01:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prasun Maiti <prasunmaiti87@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: Reduce endian conversion for REG Host Commands
References: <201606220027.euqOehrM%fengguang.wu@intel.com>
	<1466591125-32128-1-git-send-email-prasunmaiti87@gmail.com>
Date: Wed, 22 Jun 2016 13:51:47 +0300
In-Reply-To: <1466591125-32128-1-git-send-email-prasunmaiti87@gmail.com>
	(Prasun Maiti's message of "Wed, 22 Jun 2016 15:55:25 +0530")
Message-ID: <87eg7ph4xo.fsf@kamboji.qca.qualcomm.com> (sfid-20160622_130204_997605_55B45A49)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prasun Maiti <prasunmaiti87@gmail.com> writes:

> For multiple REG Host Commands (e.g HostCmd_CMD_802_11_EEPROM_ACCESS,
> HostCmd_CMD_MAC_REG_ACCESS etc.) "cpu_to_leX"-converted values are
> saved to driver. So, "leX_to_cpu" conversion is required too many
> times afterwards in driver.
>
> This patch reduces the endian: conversion without saving "cpu_to_leX"
> converted values in driver. This will convert endianness in prepare
> command and command response path.
>
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>

If you send a new version of the patch mark it as [PATCH v2] and always
include a change log so that people don't need to guess what has
changed:

http://kernelnewbies.org/FirstKernelPatch#head-5c81b3c517a1d0bbc24f92594cb734e155fcbbcb

So now you should send a v3 and include a changelog.

-- 
Kalle Valo
