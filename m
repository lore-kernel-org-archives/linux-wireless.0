Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55240 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbE1Itd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 04:49:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: simplify check stripping v2 NVRAM
References: <1432107261-7350-1-git-send-email-zajec5@gmail.com>
Date: Thu, 28 May 2015 11:49:25 +0300
In-Reply-To: <1432107261-7350-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 20 May 2015
 09:34:21 +0200")
Message-ID: <87a8wpytm2.fsf@kamboji.qca.qualcomm.com> (sfid-20150528_104938_212093_923D1D6A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Comparing NVRAM entry with a full filtering string is simpler than
> comparing it with a short prefix and then checking random chars at magic
> offsets. The cost of snprintf relatively low, we execute it just once.
> Tested on BCM43602 with NVRAM hacked to use V2 format.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied manually.

-- 
Kalle Valo
