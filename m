Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48084 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934773AbeFROre (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 10:47:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt7601u: remove warning when avg_rssi is zero
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180609101043.GA28502@redhat.com>
References: <20180609101043.GA28502@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org,
        Adam Borowski <kilobyte@angband.pl>
Message-Id: <20180618144733.C1A0B60B11@smtp.codeaurora.org> (sfid-20180618_164739_392302_1E729B91)
Date: Mon, 18 Jun 2018 14:47:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> It turned out that we can run calibration without already received
> frames with RSSI data. In such case just don't update AGC register
> and don't print the warning.
> 
> Fixes: b305a6ab0247 ("mt7601u: use EWMA to calculate avg_rssi")
> Reported-by: Adam Borowski <kilobyte@angband.pl>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

As the first release for b305a6ab0247 was v4.18-rc1, I'll queue this to 4.18.

-- 
https://patchwork.kernel.org/patch/10455479/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
