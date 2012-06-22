Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761524Ab2FVHiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 03:38:00 -0400
Message-ID: <1340350672.4491.4.camel@jlt3.sipsolutions.net> (sfid-20120622_093803_019807_4FA7B705)
Subject: Re: [PATCH] cfg80211/mac80211: 802.11ac changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 09:37:52 +0200
In-Reply-To: <4FE42052.9090909@broadcom.com> (sfid-20120622_093629_355882_C67AFB69)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E4E@mbx022-e1-nj-10.exch022.domain.local>
	 <4FE42052.9090909@broadcom.com> (sfid-20120622_093629_355882_C67AFB69)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 09:35 +0200, Arend van Spriel wrote:
> On 06/22/2012 09:27 AM, Mahesh Palivela wrote:
> > 11ac changes to push VHT cap through NL layer.
> > ieee structs, constants for 11ac.
> > VHT cap IE in ProbeReq.
> > 
> > Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
> > Cc: Johannes Berg <johannes@sipsolutions.com>
> 
> Not looked at the patch, but I assumed mac80211/cfg80211 patches should
> be submitted to Johannes or is the mac80211 repository not in use yet.

They should be but I'll pick them up from the mailing list too if
needed. No need to Cc John though :)

And this will go to mac80211-next, obviously.

johannes

