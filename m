Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:38285
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761695Ab2FVKLd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 06:11:33 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] cfg80211/mac80211: 802.11ac changes
Date: Fri, 22 Jun 2012 10:11:31 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E80@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120622_121745_149314_CE99E1FB)
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

I am working on them Johannes. Assoc is the next item....

Thanks,
Mahesh