Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:34013 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbXK0Jsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 04:48:39 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1192706ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 01:48:37 -0800 (PST)
Message-ID: <c85cb4470711270148y418eb52ftabe0ce77878c8ba3@mail.gmail.com> (sfid-20071127_094848_150696_38E39A3D)
Date: Tue, 27 Nov 2007 11:48:36 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: [PATCH 06/15] mac80211: adding 802.11n essential A-MSDU Rx capability
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
In-Reply-To: <200711261340.54406.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <119608649124-git-send-email-ron.rindjunsky@intel.com>
	 <200711261340.54406.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> > index 9caf124..247af42 100644
> > --- a/net/mac80211/ieee80211_i.h
> > +++ b/net/mac80211/ieee80211_i.h
> > @@ -155,6 +155,7 @@ struct ieee80211_txrx_data {
> >                       int load;
> >                       u32 tkip_iv32;
> >                       u16 tkip_iv16;
> > +                     u8  amsdu_frame;
> A flag would be preferable.
>

I agree, will be more efficient.
If no one has a solid objection for altering the variable to a flag I
will issue a patch on top of this patch that will do it.

> -Michael Wu
>
>
