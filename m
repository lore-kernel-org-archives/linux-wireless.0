Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48850 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeH1QgN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:36:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Yuan-Chi Pang <fu3mo6goo@gmail.com>
Cc: johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix to follow standard
References: <1535423074-130862-1-git-send-email-fu3mo6goo@gmail.com>
Date: Tue, 28 Aug 2018 15:44:39 +0300
In-Reply-To: <1535423074-130862-1-git-send-email-fu3mo6goo@gmail.com>
        (Yuan-Chi Pang's message of "Tue, 28 Aug 2018 10:24:34 +0800")
Message-ID: <87ftyyu0co.fsf@purkki.adurom.net> (sfid-20180828_144454_248038_234E719B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yuan-Chi Pang <fu3mo6goo@gmail.com> writes:

> IEEE 802.11-2016 14.10.8.3 HWMP sequence numbering says:
> If it is a target mesh STA, it shall update its own HWMP SN to
> maximum (current HWMP SN, target HWMP SN in the PREQ element) + 1
> immediately before it generates a PREP element in response to a
> PREQ element.
>
> Signed-off-by: Yuan-Chi Pang <fu3mo6goo@gmail.com>

The patch title is quite generic, you could make it a bit more
informative and unique. For example:

mac80211: fix HWMP sequence numbering to follow standard

-- 
Kalle Valo
