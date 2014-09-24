Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:47994 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIXHAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 03:00:40 -0400
Received: by mail-we0-f179.google.com with SMTP id u56so5641603wes.38
        for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 00:00:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140923143234.23585.2139.stgit@potku.adurom.net>
References: <20140923143219.23585.34114.stgit@potku.adurom.net>
	<20140923143234.23585.2139.stgit@potku.adurom.net>
Date: Wed, 24 Sep 2014 09:00:39 +0200
Message-ID: <CA+BoTQ=O8j1x-71SCLq9ZiXBU28Ax9M7tyfbvB=mjsWUwgPSjw@mail.gmail.com> (sfid-20140924_090043_354328_DF0E5414)
Subject: Re: [PATCH v2 3/3] ath10k: add cal_data debugfs file
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 September 2014 16:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 101c6f9cf2a8..426341480262 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
[...]
> +static int ath10k_cal_data_open(struct inode *inode, struct file *file)

Shouldn't functions in debug.c have ath10k_debug_ prefix? I'm aware
other fops stuff doesn't include the _debug word as well so this is
somewhat consistent with the current code but is this okay in the
grand scheme of things? Just wondering.


Michał
