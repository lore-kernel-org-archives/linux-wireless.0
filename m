Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57176 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbbCGH1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 02:27:06 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: ebiederm@xmission.com (Eric W. Biederman),
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] build fixes for iwlwifi
References: <874mpy2gw5.fsf@kamboji.qca.qualcomm.com>
	<87fv9h7cwl.fsf@x220.int.ebiederm.org>
Date: Sat, 07 Mar 2015 09:27:00 +0200
In-Reply-To: <87fv9h7cwl.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 06 Mar 2015 20:35:22 -0600")
Message-ID: <87r3t11d4r.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_082941_857716_222BA9B4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ebiederm@xmission.com (Eric W. Biederman) writes:

> drivers/net/wireles/iwlwifi/mvm fails to build for me on
> net-next.
>
> Eric W. Biederman (2):
>       iwlwifi: mvm: Fix the build of mvm/mac-ctxt.c with debugfs disabled
>       iwlwifi: mvm: Fix the build of mvm/phy-ctxt.c with debugfs disabled

Emmanuel, are you ok with these? Can I apply them?

-- 
Kalle Valo
