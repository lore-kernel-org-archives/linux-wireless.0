Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55755 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbE1Ixf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 04:53:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH V4] brcmfmac: allow NVRAM values to contain spaces
References: <1432331128-24011-1-git-send-email-zajec5@gmail.com>
	<1432365333-1074-1-git-send-email-zajec5@gmail.com>
Date: Thu, 28 May 2015 11:53:27 +0300
In-Reply-To: <1432365333-1074-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sat, 23 May 2015
 09:15:33 +0200")
Message-ID: <87twuxxeuw.fsf@kamboji.qca.qualcomm.com> (sfid-20150528_105339_775014_73E5842F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Platform NVRAMs often contain values with spaces. Even if right now most
> firmware-supported entries are simple values, we shouldn't reject these
> with spaces. It was semi-confirmed by Broadcom in the early patch adding
> support for platform NVRAMs.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied manually.

-- 
Kalle Valo
