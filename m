Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62754 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbcFNNVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 09:21:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] wil6210: fix chan check in wil_p2p_listen
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1465405668-15881-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	Maya Erez <qca_merez@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qualcomm.com>
Message-ID: <a36f18af8bae45f9a4ac3438323b072b@euamsexm01a.eu.qualcomm.com> (sfid-20160614_152120_780797_29D81337)
Date: Tue, 14 Jun 2016 15:20:49 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qualcomm.com> wrote:
> In wil_p2p_listen chan is checked to protect against NULL
> pointer access only before setting channel = chan->hw_value.
> Add a global parameter check to cover all accesses to chan.
> 
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Thanks, 2 patches applied to ath-next branch of ath.git:

9c830abe9194 wil6210: fix chan check in wil_p2p_listen
eb57a5b387d6 wil6210: abort P2P search when stopping P2P device

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9165315/

