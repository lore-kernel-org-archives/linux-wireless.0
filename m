Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55680 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbbE1Iwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 04:52:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: treat \0 as end of comment when parsing NVRAM
References: <1432123194-12584-1-git-send-email-zajec5@gmail.com>
Date: Thu, 28 May 2015 11:52:37 +0300
In-Reply-To: <1432123194-12584-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 20 May 2015
 13:59:54 +0200")
Message-ID: <87y4k9xewa.fsf@kamboji.qca.qualcomm.com> (sfid-20150528_105252_738810_092AB476)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> This fixes brcmfmac dealing with NVRAM coming from platform e.g. from a
> flash MTD partition. In such cases entries are separated by \0 instead
> of \n which caused ignoring whole content after the first "comment".
> While platform NVRAM doesn't usually contain comments, we switch to
> COMMENT state after e.g. finding an unexpected char in key name.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied manually.

-- 
Kalle Valo
