Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47579 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbbHYM1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 08:27:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: check all combinations when setting wiphy's addresses
References: <1440022602-6943-1-git-send-email-zajec5@gmail.com>
Date: Tue, 25 Aug 2015 15:27:01 +0300
In-Reply-To: <1440022602-6943-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Thu, 20 Aug 2015
 00:16:42 +0200")
Message-ID: <87pp2b5zai.fsf@kamboji.qca.qualcomm.com> (sfid-20150825_142711_263935_1FACEB47)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Broadcom is working on better reflection of interface combinations. With
> upcoming patches we may have 1st combination supporting less interfaces
> than others.
> To don't run out of addresses check all combinations to find the one
> with the greatest max_interfaces value.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied manually.

-- 
Kalle Valo
