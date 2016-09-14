Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8246 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763955AbcINOUA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 10:20:00 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 10/21] ath10k: support logging ath10k_info as
 KERN_DEBUG
Date: Wed, 14 Sep 2016 14:19:55 +0000
Message-ID: <87k2eeef79.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_162031_139709_57A5E3EE)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-11-git-send-email-greearb@candelatech.com>
In-Reply-To: <1462986153-16318-11-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Wed, 11 May 2016 10:02:22        -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Helps keep messages off of (serial) console when
> that is desired.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Isn't /proc/sys/kernel/print exactly for this purpose? At least I recall
using it.

--=20
Kalle Valo=
