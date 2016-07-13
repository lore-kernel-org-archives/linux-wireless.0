Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53919 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbcGMPu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 11:50:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH v3 1/2] mwifiex: add manufacturing mode support
References: <1468417703-32716-1-git-send-email-akarwar@marvell.com>
Date: Wed, 13 Jul 2016 18:50:11 +0300
In-Reply-To: <1468417703-32716-1-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Wed, 13 Jul 2016 19:18:22 +0530")
Message-ID: <87twfta66k.fsf@purkki.adurom.net> (sfid-20160713_175211_290417_52A553DC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> By default normal mode is chosen when driver is loaded. This patch adds
> a provision to choose manufacturing mode via module parameters.
>
> Command to load driver in manufacturing mode
> insmod mwifiex.ko mfg_mode=1 and mfg_firmware=mrvl/firmware.
>
> Tested-by: chunfan chen <jeffc@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Why the mfg_firmware module parameter?

-- 
Kalle Valo
