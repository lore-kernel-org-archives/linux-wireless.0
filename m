Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60727 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbbCBO56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 09:57:58 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: respect reason when deleting (deauthenticating) STA
References: <1423392707-12417-1-git-send-email-zajec5@gmail.com>
Date: Mon, 02 Mar 2015 16:57:49 +0200
In-Reply-To: <1423392707-12417-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 8 Feb 2015
 11:51:47 +0100")
Message-ID: <87d24rbg5u.fsf@kamboji.qca.qualcomm.com> (sfid-20150302_155808_689165_5BCC3D5F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Starting with kernel 3.19 reason is provided by cfg80211.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied.

-- 
Kalle Valo
