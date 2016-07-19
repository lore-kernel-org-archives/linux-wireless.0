Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36232 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbcGSR7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 13:59:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k_hw: fix spectral scan on AR9285 and newer
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160711083539.58649-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <dec83f71fc554e1c804271fc39d26f00@eusanexr01a.eu.qualcomm.com> (sfid-20160719_195940_357065_40C6C133)
Date: Tue, 19 Jul 2016 10:58:31 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> The register layout of AR_PHY_SPECTRAL_SCAN has changed, only AR9280
> uses the old layout
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Thanks, 1 patch applied to ath-next branch of ath.git:

7d6c2d1e34ef ath9k_hw: fix spectral scan on AR9285 and newer

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9223035/

