Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760188Ab2FVGyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 02:54:53 -0400
Message-ID: <1340348085.4491.2.camel@jlt3.sipsolutions.net> (sfid-20120622_085456_699839_85EE45F4)
Subject: RE: [RFC v3] cfg80211/mac80211: 802.11ac changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 08:54:45 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E0F@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3CE8@mbx022-e1-nj-10.exch022.domain.local>
	 <1340302471.4489.43.camel@jlt3.sipsolutions.net>
	 <4FE36942.1090801@broadcom.com>
	 <1340303967.4489.44.camel@jlt3.sipsolutions.net>
	 ,<4FE36FC1.2020702@broadcom.com>
	 <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3D6F@mbx022-e1-nj-10.exch022.domain.local>
	,<1340346809.4491.0.camel@jlt3.sipsolutions.net>
	 <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E0F@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 06:47 +0000, Mahesh Palivela wrote:

> > [MP] Should I declare another constant for this?
> > +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895   0
> 
> Yes I think that would be good

> But every VHT capability bitfields value zero has a meaning.
> Max_MPDU_len field is 2 bits. 0 - 3895, 1 - 7991, 2 - 11454, 3 - reserved
> Supp_ch_width field is 2 bits. 0 - 160 MHz not supp, 1 - 160 MHz supp, 2 - 160/80+80 supp.
> My point is should we have constant defines for all of those?

Not all, some are truly boolean like IEEE80211_VHT_CAP_TXSTBC which you
can turn on and off. I just think that for the ones that aren't really
bool because they occupy more than one bit would be worthwhile to list
all option?

Oh also can you send as [PATCH] soon? :)

johannes

