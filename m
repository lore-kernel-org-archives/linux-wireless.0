Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40711 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbcE1ISn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 May 2016 04:18:43 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Eduardo Abinader <eduardo.abinader@riverbed.com>,
	<ath9k-devel@lists.ath9k.org>, <ath9k-devel@qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: allow tx99 for ar9002 based cards
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1462797520-7239-1-git-send-email-eduardo.abinader@riverbed.com>
To: Eduardo Abinader <eabinader@ocedo.com>
Message-ID: <a198d169d7ce485e91bb56591efc7570@euamsexm01a.eu.qualcomm.com> (sfid-20160528_101848_576946_92947E76)
Date: Sat, 28 May 2016 10:18:35 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eduardo Abinader <eabinader@ocedo.com> wrote:
> As there is current support for ar9002 tx99 mode, just allow
> to init debugfs and enable tx99.
> 
> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>

Thanks, 1 patch applied to ath.git:

e94610cc1c8f ath9k: allow tx99 for ar9002 based cards

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9046181/

