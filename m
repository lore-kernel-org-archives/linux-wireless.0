Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57071 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbK3LAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 06:00:53 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 11/11] brcmfmac: Fix double free on exception at module load.
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
	<1448447567-12189-12-git-send-email-arend@broadcom.com>
Date: Mon, 30 Nov 2015 13:00:49 +0200
In-Reply-To: <1448447567-12189-12-git-send-email-arend@broadcom.com> (Arend
	van Spriel's message of "Wed, 25 Nov 2015 11:32:47 +0100")
Message-ID: <87oaebkazi.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_120056_581233_092C7E3C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> From: Hante Meuleman <meuleman@broadcom.com>
>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

In the future no empty commit logs, please.

-- 
Kalle Valo
