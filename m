Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14338 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760562Ab3JPJTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 05:19:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/7] ath10k: add sanity checks for monitor management
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
	<1381858196-17000-3-git-send-email-michal.kazior@tieto.com>
Date: Wed, 16 Oct 2013 12:19:09 +0300
In-Reply-To: <1381858196-17000-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 15 Oct 2013 10:29:51 -0700")
Message-ID: <87siw17euq.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_111927_582650_2629427B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Add a few checks and warnings to make it easier to
> track any kind of monitor vdev mismanagement.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +	if (!ar->monitor_present) {
> +		ath10k_warn("mac montor stop -- monitor is not present\n");
> +		return -EINVAL;
> +	}

[...]

> +	if (!ar->monitor_present) {
> +		ath10k_warn("mac montor stop -- monitor is not present\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!ar->monitor_enabled) {
> +		ath10k_warn("mac montor stop -- monitor is not enabled\n");
> +		return -EINVAL;
> +	}

s/montor/monitor/

-- 
Kalle Valo
