Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaC1NZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:25:33 -0400
Message-ID: <1396013129.4175.29.camel@jlt4.sipsolutions.net> (sfid-20140328_142540_088342_759A9A72)
Subject: Re: [PATCH v2 12/13] mac80211: compute chanctx refcount on-the-fly
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 28 Mar 2014 14:25:29 +0100
In-Reply-To: <CA+BoTQ=i+XdwCcixiWTT9zchyLeXq2-rr5XbvWAVs1kXx=VjUQ@mail.gmail.com> (sfid-20140328_142229_136741_7ECB5A6B)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-13-git-send-email-michal.kazior@tieto.com>
	 <1396012272.4175.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=i+XdwCcixiWTT9zchyLeXq2-rr5XbvWAVs1kXx=VjUQ@mail.gmail.com>
	 (sfid-20140328_142229_136741_7ECB5A6B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-28 at 14:22 +0100, Michal Kazior wrote:
> On 28 March 2014 14:11, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
> >> It doesn't make much sense to store refcount in
> >> the chanctx structure. One still needs to hold
> >> chanctx_mtx to get the value safely. Besides,
> >> refcount isn't on performance critical paths.
> >>
> >> This will make implementing chanctx reservation
> >> refcounting a little easier.
> >
> > Why bother with patch 11 then?
> 
> I try to do one-thing-at-a-time. 11 is a fix, 12 is an enhancement. I
> can squash it if you want?

I guess it doesn't really matter, I was just wondering why you were
bothering to fix it up if you're going to remove it :)

johannes

