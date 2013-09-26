Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27293 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab3IZMiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 08:38:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 05/13] ath10k: split ath10k_wmi_service_ready_event_rx
References: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
	<1380187792-25626-6-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 26 Sep 2013 15:38:39 +0300
In-Reply-To: <1380187792-25626-6-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 26 Sep 2013 11:29:44 +0200")
Message-ID: <8761tnrc4w.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_150917_571344_C84723C8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Since the both firmwares we are going to support,
> have significantly different APIs (WMI and shared
> structures), it's easier to actually split the whole
> event handling functions, instead cutting them inside.
>
> The fork starts now on ath10k_wmi_process_rx().
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

[...]

> +	complete(&ar->wmi.service_ready);
> +}
> +
> +
>  static int ath10k_wmi_ready_event_rx(struct ath10k *ar, struct sk_buff *skb)

Only one empty line between functions.

-- 
Kalle Valo
