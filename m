Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24881 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3HGHzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:55:42 -0400
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	<ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix race in heart beat polling
References: <1371712640-12834-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Wed, 7 Aug 2013 10:55:31 +0300
In-Reply-To: <1371712640-12834-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Thu, 20 Jun 2013 12:47:20
	+0530")
Message-ID: <871u666iks.fsf@kamboji.qca.qualcomm.com> (sfid-20130807_095546_934351_08B03ADE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

> From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
>
> Make sure to cancel heart beat timer before
> freeing wmi to avoid potential NULL pointer
> dereference.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
