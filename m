Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:42303 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYCILnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 07:43:35 -0400
Received: by rv-out-0910.google.com with SMTP id k20so794545rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 04:43:33 -0700 (PDT)
Message-ID: <c85cb4470803090443v3748a986vfc909c984369a4a7@mail.gmail.com> (sfid-20080309_114343_065367_1D6D761B)
Date: Sun, 9 Mar 2008 13:43:33 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com, "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1204829243.25502.137.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <200803061902.33865.IvDoorn@gmail.com>
	 <1204826767.25502.135.camel@johannes.berg>
	 <200803061927.09891.IvDoorn@gmail.com>
	 <1204829243.25502.137.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > You could also just make a patch for exactly this and ask Ron to merge
> > > it together with this?
> >
> > Well that patch would then be completely untested (I code, but have hardly time
> > to perform the testing myself).
>
> Heh ok.
>
> > I can already say that the patch from Ron will work despite the my
> > remark about the different meaning of the qid field.
>
> Oh if my (I'm to blame for the rt2x00 changes, not Ron) changes will not
> totally break it that's fine then.
>
> johannes
>

John, Johannes, what will be the preferred way to continue? it seems
that Ivo and Michael agree that the adjustments needed can be inserted
quite fast. would you like to re-base and merge the current RFC as a
patch and fix things on top of it, or to merge all the fixes and push
it at once?
