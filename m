Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36773 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbbETNiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:38:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: [PATCH FIX] ssb: extend fix for PCI related silent reboots to all chipsets
References: <1431495398-15238-1-git-send-email-zajec5@gmail.com>
Date: Wed, 20 May 2015 16:38:00 +0300
In-Reply-To: <1431495398-15238-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 13 May 2015
 07:36:38 +0200")
Message-ID: <87bnhf9xon.fsf@kamboji.qca.qualcomm.com> (sfid-20150520_153813_239513_E42534A4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Recent fix for BCM4704 reboots has to be extended as the same problem
> affects Linksys WRT350N v1 (BCM4705).
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Reported-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
> ---
> Kalle: it's quite trivial, you may consider taking it for 4.1.

Thanks, manually applied to wireless-drivers.git.

-- 
Kalle Valo
