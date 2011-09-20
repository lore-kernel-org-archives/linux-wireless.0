Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50649 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1ITV05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 17:26:57 -0400
Received: by qyk7 with SMTP id 7so1022082qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 14:26:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E78FFEB.1090301@openwrt.org>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
 <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net>
 <36569806.Rgjanm0GiI@alex-1> <1316521312.3953.27.camel@jlt3.sipsolutions.net>
 <CAB=NE6VDSTAKK0pmyBOz6hw1pbxo7U6dxbrvg_F-y6CDB0paKw@mail.gmail.com>
 <4E78D990.3090601@openwrt.org> <CAB=NE6VZeCViBZA9++NcgZ2JcDppbp3OuagRVK02ENjdb-MAQA@mail.gmail.com>
 <4E78DF6F.3060304@openwrt.org> <CAB=NE6XqT_ZUV7F+0ZvCs-WgxZnJn3onMiWNtBi=+eCkMZMgPA@mail.gmail.com>
 <4E78EA05.6000005@openwrt.org> <CAB=NE6WhaNpjpernCGY9skU+e+cUurPxi7r-FKaeH5iybeqGEg@mail.gmail.com>
 <4E78FFEB.1090301@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 20 Sep 2011 14:26:36 -0700
Message-ID: <CAB=NE6W76dg_KaN6jB-OQ2xf7Xx93a4ruqzQDwg5+rcwOcSfXg@mail.gmail.com> (sfid-20110920_232700_630490_50F36F10)
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Javier Cardona <javier@cozybit.com>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 2:04 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> This is not really an IBSS specific issue. It applies to WDS or monitor mode
> as well.

Excellent point!

> If we want to properly enforce Annex J channel pairs, this needs to
> be moved to cfg80211.

This does not still address the issue of one peer finding out it
cannot deal with an HT40 pair and correcting the topology and
propagating this out. Not yet sure if for 802.11ac we'll need
something similar but its worth considering.

  Luis
