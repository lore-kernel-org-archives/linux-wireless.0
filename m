Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31233 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2HNOYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 10:24:19 -0400
Message-ID: <502A5F8B.4000303@qca.qualcomm.com> (sfid-20120814_162428_761031_E3225DBB)
Date: Tue, 14 Aug 2012 17:24:11 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: reconfigure RSN capabilities when restarting
 AP
References: <1343438007-5252-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1343438007-5252-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2012 04:13 AM, Thomas Pedersen wrote:
> If the firmware decides to initiate a channel switch on an AP vif
> running an RSN BSS, reconfigure the saved RSN IE capabilities as well.
> 
> Fixes a bug where the beacon and 4-way handshake would have a capability
> mismatch after a channel switch, since the firmware apparently clears
> these on an AP disconnect.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
