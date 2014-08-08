Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61468 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaHHLBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 07:01:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/6] ath10k: remove pci features var
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	<1407402212-29809-4-git-send-email-michal.kazior@tieto.com>
Date: Fri, 8 Aug 2014 14:01:03 +0300
In-Reply-To: <1407402212-29809-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:03:29 +0200")
Message-ID: <874mxnz1n4.fsf@kamboji.qca.qualcomm.com> (sfid-20140808_130116_450481_6CAE4A20)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The ATH10K_PCI_FEATURE_MSI_X was originally
> introduced to support both chips QCA988Xv1 and
> QCA988Xv2. Since v1 isn't supported anymore it
> doesn't make sense to keep the feature flag
> around. Since this is the last one remove the
> whole thing.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/pci.h
> +++ b/drivers/net/wireless/ath/ath10k/pci.h
> @@ -135,13 +135,6 @@ struct service_to_pipe {
>  	u32 pipenum;
>  };
>  
> -enum ath10k_pci_features {
> -	ATH10K_PCI_FEATURE_MSI_X		= 0,
> -
> -	/* keep last */
> -	ATH10K_PCI_FEATURE_COUNT
> -};

I wouldn't be too surprised if we need this again at some point. But we
can then add it back.

-- 
Kalle Valo
