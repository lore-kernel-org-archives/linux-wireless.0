Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35618 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbcGDAd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 20:33:27 -0400
Received: by mail-it0-f51.google.com with SMTP id j185so19614650ith.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jul 2016 17:33:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467371245-5426-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1467371245-5426-1-git-send-email-vthiagar@qti.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 4 Jul 2016 10:33:07 +1000
Message-ID: <CAGRGNgVHuWVf4i3MmPUKJuGQ+MmFVY-AVdVbgYbLX=uyBCu=mQ@mail.gmail.com> (sfid-20160704_023331_525375_1CB9B112)
Subject: Re: [PATCH] ath10k: Fix possible wrong rx_busy time reporting in QCA4019
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Fri, Jul 1, 2016 at 9:07 PM, Vasanthakumar Thiagarajan
<vthiagar@qti.qualcomm.com> wrote:
> As hw cycle counters in QCA4019 wraparound independantly in QCA4019
> it is possible cycle counter and rx clear counter would wraparound
> at the same time. Current logic assumes only one of the counters
> would wraparound at anytime. Fix this by moving 'else' part to
> another 'if'.
>
> Fixes: 8e100354a98 ("ath10k: fix cycle counter wraparound handling for QCA4019")
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
