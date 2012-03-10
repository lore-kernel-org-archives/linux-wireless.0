Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32941 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2CJGip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 01:38:45 -0500
Received: by dajr28 with SMTP id r28so2358493daj.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 22:38:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331292513.3491.1.camel@jlt3.sipsolutions.net>
References: <1331137230-12430-1-git-send-email-helmut.schaa@googlemail.com>
	<1331139615.3519.18.camel@jlt3.sipsolutions.net>
	<CAGXE3d_fMnjyHJ7zkz53Dvv0eL+MKC6sDJwpvOQQrK+R=f2iBw@mail.gmail.com>
	<CAJ-Vmomm9NKr6T_PczQ_eOq-so1b-=z1dSEPyjJr35ZNcag2XA@mail.gmail.com>
	<1331292513.3491.1.camel@jlt3.sipsolutions.net>
Date: Fri, 9 Mar 2012 22:38:44 -0800
Message-ID: <CAJ-Vmom3-V5OXhcOxJJSnSfgC79_Pasa7tjXD+YR_cdwca1NEg@mail.gmail.com> (sfid-20120310_073912_010669_B962086D)
Subject: Re: [PATCH] mac80211: Limit TID buffering during BA session setup/teardown
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 March 2012 03:28, Johannes Berg <johannes@sipsolutions.net> wrote:

>> (That said, what may be nice is applying backpressure to the source
>> interface of the frame(s), eg by sending PAUSE frames to the ethernet
>> port(s), but that's just me..)
>
> That would happen from the bridging code when the interface queues are
> stopped & get full, right?

Sure, as long as the queues aren't too full. I haven't looked into
whether openwrt sends PAUSE frames - Felix?


Adrian
