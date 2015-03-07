Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:36487 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbbCGCi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 21:38:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
References: <874mpy2gw5.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 06 Mar 2015 20:35:22 -0600
In-Reply-To: <874mpy2gw5.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Fri, 06 Mar 2015 19:08:10 +0200")
Message-ID: <87fv9h7cwl.fsf@x220.int.ebiederm.org> (sfid-20150307_033927_795204_AA4638FB)
MIME-Version: 1.0
Content-Type: text/plain
Subject: [PATCH net-next 0/2] build fixes for iwlwifi
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


drivers/net/wireles/iwlwifi/mvm fails to build for me on
net-next.

Eric W. Biederman (2):
      iwlwifi: mvm: Fix the build of mvm/mac-ctxt.c with debugfs disabled
      iwlwifi: mvm: Fix the build of mvm/phy-ctxt.c with debugfs disabled

 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 7 ++++++-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)


