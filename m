Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20979 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932172AbcIBPaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:30:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: hide kernel addresses from logs using %pK format specifier
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1470318711-28986-1-git-send-email-c_mkenna@qti.qualcomm.com>
To: <c_mkenna@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mkenna@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Message-ID: <539a89901cc14f9a8a938a4d41f185cd@euamsexm01a.eu.qualcomm.com> (sfid-20160902_173023_246527_7FD50261)
Date: Fri, 2 Sep 2016 17:29:56 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_mkenna@qti.qualcomm.com wrote:
> From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> 
> With the %pK format specifier we hide the kernel addresses
> with the help of kptr_restrict sysctl.
> In this patch, %p is changed to %pK in the driver code.
> 
> The sysctl is documented in Documentation/sysctl/kernel.txt.
> 
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

75b34800a228 ath10k: hide kernel addresses from logs using %pK format specifier

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9263691/
