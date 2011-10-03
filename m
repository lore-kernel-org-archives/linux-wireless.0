Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47537 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab1JCT6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 15:58:02 -0400
Received: by qyk30 with SMTP id 30so2545691qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 12:58:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317465174-2685-1-git-send-email-hauke@hauke-m.de>
References: <1317465174-2685-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 Oct 2011 12:57:41 -0700
Message-ID: <CAB=NE6UauNcyLQ5-9zdJ=bE9Rnat-cAOnUYOgPOT=1uSAOfKNw@mail.gmail.com> (sfid-20111003_215807_163478_CEB1C44C)
Subject: Re: [PATCH] compat: add skb_tx_timestamp() and skb_defer_rx_timestamp()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 1, 2011 at 3:32 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Just add an empty implementation of these functions to do the same as
> when timestamping is deactivated.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed, thanks!

  Luis
