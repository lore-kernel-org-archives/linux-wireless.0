Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:47111 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753320AbdJMMIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 08:08:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Store coverage-class in case firmware is not booted.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1507068707-14050-1-git-send-email-greearb@candelatech.com>
References: <1507068707-14050-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>
Message-ID: <3bbdd65d31c7406a95a40c85ed03a144@euamsexm01e.eu.qualcomm.com> (sfid-20171013_140856_415062_BD35A62E)
Date: Fri, 13 Oct 2017 14:08:46 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:

> This way, we can apply the values when the NIC does come up.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

0a590a38778d ath10k: store coverage-class in case firmware is not booted

-- 
https://patchwork.kernel.org/patch/9983585/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
