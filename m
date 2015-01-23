Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38703 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbAWRty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:49:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH V2] bcma: clean bus initialization code
References: <1421435929-21499-1-git-send-email-zajec5@gmail.com>
	<1421438379-26211-1-git-send-email-zajec5@gmail.com>
Date: Fri, 23 Jan 2015 19:49:48 +0200
In-Reply-To: <1421438379-26211-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Fri, 16 Jan 2015
 20:59:39 +0100")
Message-ID: <87h9vhl743.fsf@kamboji.qca.qualcomm.com> (sfid-20150123_184958_112691_32CAC249)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> This moves main bus init code to the main.c and renames old function to
> make its purpose clear.
> Thanks to this change we'll also be able to separate scanning from
> registration (and support PCIe Gen 2 devices) in the future.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: Fix typo (s/initialiation/initialization/)
>     Put bcma_detect_chip earlier in .h to match order in .c

Thanks, applied to wireless-drivers-next.git. But to avoid any UTF-8
problems I applied this one manually from email. 'git log' and gitk look
good to me, but please do check still that the log is valid.

-- 
Kalle Valo
