Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:44646 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbdF1QyK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 12:54:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: add const to thermal_cooling_device_ops structure
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1498037010-21024-1-git-send-email-bhumirks@gmail.com>
References: <1498037010-21024-1-git-send-email-bhumirks@gmail.com>
To: Bhumika Goyal <bhumirks@gmail.com>
CC: <julia.lawall@lip6.fr>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bhumika Goyal <bhumirks@gmail.com>
Message-ID: <ba4938bc024149c4a5bbb36dd2c66fef@euamsexm01a.eu.qualcomm.com> (sfid-20170628_185446_572780_21228BD2)
Date: Wed, 28 Jun 2017 18:54:01 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhumika Goyal <bhumirks@gmail.com> wrote:

> Declare thermal_cooling_device_ops structure as const as it is only passed
> as an argument to the function thermal_cooling_device_register and this
> argument is of type const. So, declare the structure as const.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

1cdb6c9fd433 ath10k: add const to thermal_cooling_device_ops structure

-- 
https://patchwork.kernel.org/patch/9801291/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
