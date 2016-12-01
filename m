Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17653 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756063AbcLALXv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 06:23:51 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath5k: drop duplicate header vmalloc.h
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <15299de49216a2360976ca37ff774cae9d27d88b.1479991297.git.geliangtang@gmail.com>
References: <15299de49216a2360976ca37ff774cae9d27d88b.1479991297.git.geliangtang@gmail.com>
To: Geliang Tang <geliangtang@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Geliang Tang <geliangtang@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <ba878202088a44cd9a7a7b69f5d5e4b5@euamsexm01a.eu.qualcomm.com> (sfid-20161201_122411_012851_4A49E320)
Date: Thu, 1 Dec 2016 12:23:42 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geliang Tang <geliangtang@gmail.com> wrote:
> Drop duplicate header vmalloc.h from ath5k/debug.c.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Patch applied to ath-next branch of ath.git, thanks.

384abd33d5d5 ath5k: drop duplicate header vmalloc.h

-- 
https://patchwork.kernel.org/patch/9445537/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
