Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:44297 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdL0KKC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Dec 2017 05:10:02 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/3] ath10k: Add SNOC bus type for WCN3990 target
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1513872322-26636-2-git-send-email-pillair@qti.qualcomm.com>
References: <1513872322-26636-2-git-send-email-pillair@qti.qualcomm.com>
To: Rakesh Pillai <pillair@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Govind Singh" <govinds@qti.qualcomm.com>,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Message-ID: <aa68f584e8744ab68fcf2f39edf13fe4@euamsexm01a.eu.qualcomm.com> (sfid-20171227_111005_741231_A52226A7)
Date: Wed, 27 Dec 2017 11:09:55 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@qti.qualcomm.com> wrote:

> WCN3990 is integrated chipset which uses system NOC.
> Add SNOC bus type and related definitions.
> 
> Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
> Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

3 patches applied to ath-next branch of ath.git, thanks.

63855e3d6e7a ath10k: Add SNOC bus type for WCN3990 target
b796240409b3 ath10k: Add debug mask for SNOC bus type
71e9c29fbd28 ath10k: Add fw feature flag for non-bmi firmware load

-- 
https://patchwork.kernel.org/patch/10127929/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
