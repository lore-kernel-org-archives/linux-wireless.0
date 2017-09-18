Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51932 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932292AbdIRMnc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 08:43:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <yintang@qti.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [TDLS PATCH V1 0/5] Add TDLS feature for ath10k
References: <1505473420-22932-1-git-send-email-yintang@qti.qualcomm.com>
Date: Mon, 18 Sep 2017 15:43:28 +0300
In-Reply-To: <1505473420-22932-1-git-send-email-yintang@qti.qualcomm.com>
        (yintang@qti.qualcomm.com's message of "Fri, 15 Sep 2017 19:03:35
        +0800")
Message-ID: <87wp4wkwi7.fsf@purkki.adurom.net> (sfid-20170918_144338_692899_00B566AF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<yintang@qti.qualcomm.com> writes:

> From: Yingying Tang <yintang@qti.qualcomm.com>
>
> This patchset is for Rome PCIE chip, it will not affect other hardware
>
> Yingying Tang (5):
>   mac80211: Enable TDLS peer buffer STA feature
>   ath10k: Enable TDLS peer buffer STA feature
>   ath10k: Enable TDLS peer inactivity detection
>   ath10k: Avoid to set WEP key for TDLS peer
>   ath10k: Avoid to set WEP key for TDLS peer

There was a problem on patchwork.kernel.org over the weekend, but it
should be fixed now. Unfortunately your patches didn't make it to
patchwork, so please resend (as v2).

https://patchwork.kernel.org/project/linux-wireless/list/?state=*

-- 
Kalle Valo
