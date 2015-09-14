Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55129 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbbINIhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 04:37:36 -0400
Message-ID: <1442219848.2075.5.camel@sipsolutions.net> (sfid-20150914_103755_857027_3D5F21B4)
Subject: Re: [PATCH] iwlwifi: mvm: fix tof.h header guard
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Gregory Greenman <gregory.greenman@intel.com>,
	linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Sep 2015 10:37:28 +0200
In-Reply-To: <1442052291-2328-1-git-send-email-nicolas.iooss_linux@m4x.org> (sfid-20150912_121249_388301_136F5B59)
References: <1442052291-2328-1-git-send-email-nicolas.iooss_linux@m4x.org>
	 (sfid-20150912_121249_388301_136F5B59)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-09-12 at 12:04 +0200, Nicolas Iooss wrote:
> Commit ce7929186a39 ("iwlwifi: mvm: add basic Time of Flight 
> (802.11mc
> FTM) support") created drivers/net/wireless/iwlwifi/mvm/tof.h with a
> broken header guard:
> 
>     #ifndef __tof
>     #define __tof_h__
> 
>     ...
> 
>     #endif /* __tof_h__ */
> 
> Use __tof_h__ in the first line.
> 
Thanks, I applied it to our development tree.

johannes
