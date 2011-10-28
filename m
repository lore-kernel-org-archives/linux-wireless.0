Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49159 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab1J1GJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 02:09:13 -0400
Received: by gyb13 with SMTP id 13so3373642gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 23:09:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319743973.32221.4.camel@jlt3.sipsolutions.net>
References: <20111021142322.229128720@sipsolutions.net>
	<1319743973.32221.4.camel@jlt3.sipsolutions.net>
Date: Fri, 28 Oct 2011 08:09:12 +0200
Message-ID: <CAGXE3d8QJqPR5Q95ZVt+JzWRZAH5f=Nap1DT=mTmmajsAMYcWw@mail.gmail.com> (sfid-20111028_080918_220350_3F62975D)
Subject: Re: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not wait
 for ACK
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2011 at 9:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> For probe responses it can be useful to not wait for ACK
> to save airtime, so allow userspace to request not waiting
> with a new nl80211 flag.
>
> Since mac80211 needs to be updated for the new function
> prototype anyway implement it right away -- it's just a
> few lines of code.

Ah, nice!

I'll adjust my hostad patch to make use of this instead of the
radiotap flag (or maybe both, need to look into this further).

Helmut
