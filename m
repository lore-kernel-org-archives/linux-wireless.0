Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57009 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754300AbcJMNrH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 09:47:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix debug cal data file
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1474341984-19220-1-git-send-email-mar.kolya@gmail.com>
References: <1474341984-19220-1-git-send-email-mar.kolya@gmail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
CC: Nikolay Martynov <mar.kolya@gmail.com>,
        <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Message-ID: <21deaa8b2e7a4765bead3b77da17de49@euamsexm01a.eu.qualcomm.com> (sfid-20161013_154712_118595_7449A1A2)
Date: Thu, 13 Oct 2016 15:42:32 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nikolay Martynov <mar.kolya@gmail.com> wrote:
> It got broken by 0b8e3c4ca29fe2c0efd3d41a76e34a657b9f17a4
> 
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>

Actually Marty's patch fixed this in a better way so I actually took that
instead:

f67b107d4ced ath10k: cache calibration data when the core is stopped

-- 
https://patchwork.kernel.org/patch/9340953/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
