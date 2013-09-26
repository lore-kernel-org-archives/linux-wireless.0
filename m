Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29014 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab3IZMfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 08:35:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 03/13] ath10k: warn if give WMI command is not supported
References: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
	<1380187792-25626-4-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 26 Sep 2013 15:35:24 +0300
In-Reply-To: <1380187792-25626-4-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 26 Sep 2013 11:29:42 +0200")
Message-ID: <87a9izrcab.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_150916_924331_AC90D717)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This will show and make it easier to track the API
> differences in the new AP firmware.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---

[...]

> +	if (cmd_id == WMI_CMD_UNDEFINED) {
> +		ath10k_warn("command not supported by given firmware\n");
> +		return ret;
> +	}

You should print the cmd id in the warning message.

-- 
Kalle Valo
