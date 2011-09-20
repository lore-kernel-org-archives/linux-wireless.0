Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44861 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1ITVxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 17:53:03 -0400
Message-ID: <4E790B3B.9090004@openwrt.org> (sfid-20110920_235307_302663_06469E57)
Date: Tue, 20 Sep 2011 23:52:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Javier Cardona <javier@cozybit.com>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net> <36569806.Rgjanm0GiI@alex-1> <1316521312.3953.27.camel@jlt3.sipsolutions.net> <CAB=NE6VDSTAKK0pmyBOz6hw1pbxo7U6dxbrvg_F-y6CDB0paKw@mail.gmail.com> <4E78D990.3090601@openwrt.org> <CAB=NE6VZeCViBZA9++NcgZ2JcDppbp3OuagRVK02ENjdb-MAQA@mail.gmail.com> <4E78DF6F.3060304@openwrt.org> <CAB=NE6XqT_ZUV7F+0ZvCs-WgxZnJn3onMiWNtBi=+eCkMZMgPA@mail.gmail.com> <4E78EA05.6000005@openwrt.org> <CAB=NE6WhaNpjpernCGY9skU+e+cUurPxi7r-FKaeH5iybeqGEg@mail.gmail.com> <4E78FFEB.1090301@openwrt.org> <CAB=NE6W76dg_KaN6jB-OQ2xf7Xx93a4ruqzQDwg5+rcwOcSfXg@mail.gmail.com>
In-Reply-To: <CAB=NE6W76dg_KaN6jB-OQ2xf7Xx93a4ruqzQDwg5+rcwOcSfXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-20 11:26 PM, Luis R. Rodriguez wrote:
> On Tue, Sep 20, 2011 at 2:04 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  If we want to properly enforce Annex J channel pairs, this needs to
>>  be moved to cfg80211.
>
> This does not still address the issue of one peer finding out it
> cannot deal with an HT40 pair and correcting the topology and
> propagating this out. Not yet sure if for 802.11ac we'll need
> something similar but its worth considering.
Don't think of it as a topology. Each node makes its own decisions about 
HT40+/HT40-/HT20. If modes are incompatible, fallback to HT20  always 
works for communicating with a peer.

- Felix
