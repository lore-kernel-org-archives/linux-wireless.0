Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41453 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756104Ab2DZMF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 08:05:56 -0400
Message-ID: <4F993A1E.8070901@qca.qualcomm.com> (sfid-20120426_140608_066845_D9D9F4B6)
Date: Thu, 26 Apr 2012 15:05:50 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2] ath6kl: Don't advertise HT capability for incapable
 firmware
References: <1335337698-7221-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1335337698-7221-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2012 10:08 AM, Vasanthakumar Thiagarajan wrote:
> With firmwares which do not support rsn capability override
> (ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) from host would
> cause 4-way handshake failure when HT cap is advertised.
> To fix this, do not advertise HT cap with cfg80211 for
> those fw.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
