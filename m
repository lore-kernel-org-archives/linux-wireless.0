Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44968 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbeELJHB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:07:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jeff Johnson <jjohnson@codeaurora.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2] ath10k: remove variables which set but not used
References: <20180507093948.GA7905@blackstone>
        <4abfd7695766fe156187a12c00320a55@codeaurora.org>
        <4abd25ee9bfcb0a41c5c4cda6e19972b@codeaurora.org>
Date: Sat, 12 May 2018 12:06:57 +0300
In-Reply-To: <4abd25ee9bfcb0a41c5c4cda6e19972b@codeaurora.org> (Jeff Johnson's
        message of "Tue, 08 May 2018 07:53:22 -0700")
Message-ID: <87in7tz1hq.fsf@purkki.adurom.net> (sfid-20180512_110704_963158_99245555)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Johnson <jjohnson@codeaurora.org> writes:

> On 2018-05-07 02:39, Kenneth Lu wrote:
>> Variable buf_len and num_vdev_stats are bging assigned but never read.
>
> typo: bging => being

I fixed this in the pending branch.

-- 
Kalle Valo
