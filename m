Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbeAYFdH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 00:33:07 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/8] wil6210: add Talyn PCIe device ID
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516526083-31389-2-git-send-email-merez@codeaurora.org>
References: <1516526083-31389-2-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Message-Id: <20180125053306.E74186028B@smtp.codeaurora.org> (sfid-20180125_063310_786271_0AD2A834)
Date: Thu, 25 Jan 2018 05:33:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

> PCIe device ID has changed in Talyn.
> Add this ID to wil6210_pcie_ids list to allow
> recognition of Talyn device.
> 
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

8 patches applied to ath-next branch of ath.git, thanks.

10cd2d45f6c7 wil6210: add Talyn PCIe device ID
4fe1fccecf87 wil6210: recognize Talyn JTAG ID
4276d7711e7c wil6210: add support for Talyn AHB address map
2a0efe6a32ac wil6210: support flashless device
b8e13b87b15d wil6210: configure OTP HW vectors in SW reset flow
70bcc658c0b1 wil6210: fix random failure to bring network interface up
54fca595d1ee wil6210: enlarge FW mac_rgf_ext section for Sparrow D0
81b35afa49c8 wil6210: support parsing brd file address from fw file

-- 
https://patchwork.kernel.org/patch/10176857/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
