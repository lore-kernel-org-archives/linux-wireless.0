Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62438 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaIDKEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 06:04:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Matteo Croce <matteo@openwrt.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: ATH10K_DEBUGFS depends on DEBUG_FS
References: <CAFnufp1Rg2JOLM4d6g_=uF+Nrydt0Wy_4DK85bnqNHkthD9zQw@mail.gmail.com>
Date: Thu, 4 Sep 2014 13:04:38 +0300
In-Reply-To: <CAFnufp1Rg2JOLM4d6g_=uF+Nrydt0Wy_4DK85bnqNHkthD9zQw@mail.gmail.com>
	(Matteo Croce's message of "Thu, 4 Sep 2014 10:50:39 +0200")
Message-ID: <87iol3k8g9.fsf@kamboji.qca.qualcomm.com> (sfid-20140904_120510_543351_C9B3A83D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matteo Croce <matteo@openwrt.org> writes:

> enable ath10k debugfs only when debugfs is enabled,
> fixes an invalid pointer on module insert
>
> --- a/drivers/net/wireless/ath/ath10k/Kconfig
> +++ b/drivers/net/wireless/ath/ath10k/Kconfig

This is missing Signed-off-by, so I cannot take this. Please check
Documentation/SubmittingPatches and please resend.

The safest way to submit a patch is to commit with 'git commit -s' and
then submit the commit with 'git send-email'. But first do a trial run
by submitting it to yourself.

-- 
Kalle Valo
