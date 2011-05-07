Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53107 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1EGFkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 01:40:13 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: crash when unloading the module
References: <87iptsgk5y.fsf@purkki.adurom.net>
	<1304433727.5744.107.camel@wwguy-ubuntu>
	<1304435232.3720.6.camel@jlt3.sipsolutions.net>
	<1304435272.3720.7.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 07 May 2011 08:40:09 +0300
In-Reply-To: <1304435272.3720.7.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Tue\, 03 May 2011 17\:07\:52 +0200")
Message-ID: <87tyd7f4qu.fsf@purkki.adurom.net> (sfid-20110507_074017_740484_2059951A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Dave looked at this and it turned out to most likely be a bug in the
>> intel-iommu code. A tentative patch to fix it from him is here:

[...]

> Err, no, http://david.woodhou.se/flush-unmaps-on-unbind.patch

Thanks. This patch fixes the issue. I was able to load and remove
iwlagn five times without a crash.

Tested-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
