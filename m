Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761616Ab2FVIRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 04:17:17 -0400
Message-ID: <1340353030.4491.6.camel@jlt3.sipsolutions.net> (sfid-20120622_101722_524030_846CC152)
Subject: Re: [PATCH] cfg80211/mac80211: 802.11ac changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 10:17:10 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E4E@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E4E@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

