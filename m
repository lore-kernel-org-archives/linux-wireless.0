Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:43131 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbbAGR4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 12:56:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] brcmfmac: get rid of duplicate SDIO device identifiers
References: <1420581774-32763-1-git-send-email-arend@broadcom.com>
Date: Wed, 07 Jan 2015 19:56:28 +0200
In-Reply-To: <1420581774-32763-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Tue, 6 Jan 2015 23:02:54 +0100")
Message-ID: <87387mqxtf.fsf@kamboji.qca.qualcomm.com> (sfid-20150107_185640_683217_F70A0519)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> Instead of defining SDIO device identifier in brcm80211 code use
> the defintions in linux/mmc/sdio_ids.h directly.
>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Resend patch rebased on:
>
>   commit 8a40084e7bb8f0fd32a301a64fd869726516a1df
>   Author: Maithili Hinge <maithili@marvell.com>
>   Date:   Wed Dec 31 02:36:46 2014 -0800
>
>       mwifiex: Add support for wowlan disconnect

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
