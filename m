Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:52262 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbcDPPny (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 11:43:54 -0400
Date: Sat, 16 Apr 2016 17:43:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"Dreyfuss, Haim" <haim.dreyfuss@intel.com>,
	"Coelho, Luciano" <luciano.coelho@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>
Subject: Re: WARNING: CPU: 1 PID: 2485 at
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1752
 iwl_trans_pcie_grab_nic_access+0x110/0x120 [iwlwifi]
Message-ID: <20160416154348.GA2069@cz.tnic> (sfid-20160416_174423_528843_E9485C21)
References: <20160415020710.GA2700@cz.tnic>
 <1460693762.2648.5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1460693762.2648.5.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 15, 2016 at 04:16:02AM +0000, Grumbach, Emmanuel wrote:
> [1] https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwi
> fi.git/

It is very strange to pull from this repo, git fetch is doing something
for a while now without any forward progress.

In any case, 4.5 is bad too, testing 4.4 now. I'm travelling currently
so the whole bisection deal will take a whole but I'll get to it
eventually.

Thanks for taking a look.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply. Srsly.
