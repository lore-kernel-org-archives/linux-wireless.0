Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752480AbdJKJN3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 05:13:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 4/8] rsi: handle peer connection and disconnection in p2p mode
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
        <1504085908-2163-5-git-send-email-amitkarwar@gmail.com>
Date: Wed, 11 Oct 2017 12:13:24 +0300
In-Reply-To: <1504085908-2163-5-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 30 Aug 2017 15:08:24 +0530")
Message-ID: <87tvz6vyh7.fsf@purkki.adurom.net> (sfid-20171011_111334_850860_59F1EC63)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> Parameter 'vif' is passed to inform_bss_status function to
> check the type of vif and to get vap_id.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Kbuild bot reported that this added a new warning, I suspect this is from sparse:

>> drivers/net//wireless/rsi/rsi_91x_hal.c:136:3: note: in expansion of
>> macro 'cpu_to_le16'
      cpu_to_le16((tx_params->vap_id << RSI_DESC_VAP_ID_OFST) &

Please fix.

-- 
Kalle Valo
