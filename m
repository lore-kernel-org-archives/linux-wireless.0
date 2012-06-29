Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2F2JNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 05:13:53 -0400
Message-ID: <1340961230.4644.0.camel@jlt3.sipsolutions.net> (sfid-20120629_111357_322564_37EEE3A7)
Subject: RE: [PATCH] mac80211: VHT Cap IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 29 Jun 2012 11:13:50 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0D65AB@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0D6345@mbx022-e1-nj-10.exch022.domain.local>
	 <1340953315.4488.2.camel@jlt3.sipsolutions.net>
	 <952C5D5D0470AE4FB7D8A75C6ADC71CA0D65AB@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-29 at 07:41 +0000, Mahesh Palivela wrote:
> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net] 
> Sent: Friday, June 29, 2012 12:32 PM
> To: Mahesh Palivela
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] mac80211: VHT Cap IE
> 
> On Fri, 2012-06-29 at 06:17 +0000, Mahesh Palivela wrote:
> 
> > +u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> > +							   u32 cap);
> 
> Ummmm, Arend was pretty specific... no?
> 
> johannes
> 
> sorry. Probably my email client is making it show like that. If you
> look at the indentation I have 7 tabs and 3 spaces which is like 31
> chars that accounts for full function name plus return type. 

7 tabs + 3 spaces? That's 59, which is probably what I see -- are you
sure you're using 8 space tabs?!

johannes

