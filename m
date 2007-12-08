Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:3211 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXLHO4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 09:56:09 -0500
Message-ID: <475AB087.5050209@rtr.ca> (sfid-20071208_145640_659512_4353A5A1)
Date: Sat, 08 Dec 2007 09:56:07 -0500
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
	"John W.Linville" <linville@tuxdriver.com>,
	Thomas Tuttle <linux-kernel@ttuttle.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Wu <flamingice@sourmilk.net>,
	LWML <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak
References: <20071206093922.GA7356@cvg> <1196991573.3170.43.camel@debian.sh.intel.com>
In-Reply-To: <1196991573.3170.43.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> On Thu, 2007-12-06 at 12:39 +0300, Cyrill Gorcunov wrote:
>> From: Cyrill Gorcunov <gorcunov@gmail.com>
>> Subject: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak
..

Any chance of getting LEDs support re-added to this driver,
perhaps in the 2.6.25 timeframe?

With that in there, I could finally switch the machines around here
away from the earlier ipw3945 stuff.

Thanks
