Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57687 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbcE1IYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 May 2016 04:24:42 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Eduardo Abinader <eduardo.abinader@riverbed.com>,
	<ath9k-devel@lists.ath9k.org>, <ath9k-devel@qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: Proper TX99 interrupt ref count
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1463670929-12639-1-git-send-email-eduardo.abinader@riverbed.com>
To: Eduardo Abinader <eabinader@ocedo.com>
Message-ID: <280f912735014ef9b058415b1272da4f@euamsexm01a.eu.qualcomm.com> (sfid-20160528_102454_931591_A085AC7E)
Date: Sat, 28 May 2016 10:24:34 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eduardo Abinader <eabinader@ocedo.com> wrote:
> On TX99 mode, instead of assuming interrupt mask non ATH9K_INT_GLOBAL,
> let ath9k_hw_disable_interrupts proper set interrupt ref count.
> This prevents some PCI PERR occurring specialy when setting 11b and n rates.
> 
> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>

Thanks, 1 patch applied to ath.git:

8a0a36cf98db ath9k: Proper TX99 interrupt ref count

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9127799/

