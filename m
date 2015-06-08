Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57292 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbFHLbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 07:31:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH RESEND] brcmfmac: use direct data pointer in NVRAM parser struct
References: <1432813063-30922-1-git-send-email-zajec5@gmail.com>
	<1433448667-3493-1-git-send-email-zajec5@gmail.com>
Date: Mon, 08 Jun 2015 14:31:36 +0300
In-Reply-To: <1433448667-3493-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Thu, 4 Jun 2015
 22:11:07 +0200")
Message-ID: <87vbeyjv1j.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_133146_724381_3782CE60)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> As we plan to add support for platform NVRAM we should store direct
> data pointer without the extra struct firmware layer. This will allow
> us to support other sources with the only requirement being u8 buffer.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied manually.

-- 
Kalle Valo
