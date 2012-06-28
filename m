Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:36370
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817Ab2F1Kwu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 06:52:50 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] cfg80211/mac80211: 802.11ac changes
Date: Thu, 28 Jun 2012 10:52:48 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0D608D@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120628_125253_360247_C960A0A4)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E4E@mbx022-e1-nj-10.exch022.domain.local>,<1340353030.4491.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340353030.4491.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Friday, June 22, 2012 1:47 PM
To: Mahesh Palivela
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211/mac80211: 802.11ac changes

On Fri, 2012-06-22 at 07:27 +0000, Mahesh Palivela wrote:
> 11ac changes to push VHT cap through NL layer.
> ieee structs, constants for 11ac.
> VHT cap IE in ProbeReq.

Thanks. I will probably rewrite this commit log though ...

Since this is clearly not everything that's needed, what are your plans
for doing the other needed things?

 * assoc handling
 * VHT BSS selector
 * VHT station capability handling

etc?

johannes

Johannes, Is this patch commited? mac80211-next? wireless-testing-next?
Let me know.

Thanks,
Mahesh