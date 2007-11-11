Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:63247 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbXKKADn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 19:03:43 -0500
Received: by rv-out-0910.google.com with SMTP id k20so821161rvb
        for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2007 16:03:43 -0800 (PST)
Message-ID: <445f43ac0711101603s18cd70a7lb70dedea8cc5c3c0@mail.gmail.com> (sfid-20071111_000348_874704_6D2CAF09)
Date: Sat, 10 Nov 2007 16:03:42 -0800
From: "Javier Cardona" <javier@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
Cc: "Luis Carlos Cobo" <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1194689500.7258.61.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>
	 <1194689500.7258.61.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On 11/10/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -474,6 +474,7 @@ enum ieee80211_if_types {
> >       IEEE80211_IF_TYPE_AP,
> >       IEEE80211_IF_TYPE_STA,
> >       IEEE80211_IF_TYPE_IBSS,
> > +     IEEE80211_IF_TYPE_MESH,
>
> What happened to Dan's suggestion of calling this MESH_STA? And maybe in
> nl80211 as well? I might've missed something, was there a conclusion?

A mesh AP would have two interfaces, each with a different MAC
address.  One IF_TYPE_MESH, the other IF_TYPE_AP.  Support for MAP, as
you suggested, would be implemented in hostapd.

Javier
