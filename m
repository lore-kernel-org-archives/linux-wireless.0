Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:48417 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYAVU00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 15:26:26 -0500
Received: by wa-out-1112.google.com with SMTP id v27so4587149wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 12:26:25 -0800 (PST)
Message-ID: <1ba2fa240801221226ra00fd76x8724b51023717b5e@mail.gmail.com> (sfid-20080122_202629_912340_33C7B3BD)
Date: Tue, 22 Jan 2008 22:26:25 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [RFC] mac80211: proper short-slot handling
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"bruno randolf" <br1@einfach.org>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Yanbo Li" <dreamfly281@gmail.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <200801161751.58244.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1199974496.3861.80.camel@johannes.berg>
	 <200801161737.00682.IvDoorn@gmail.com>
	 <1200501699.8708.9.camel@johannes.berg>
	 <200801161751.58244.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 16, 2008 6:51 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Wednesday 16 January 2008, Johannes Berg wrote:
> >
>
> > > John already merged the 2.0.14 release into the everything branch,
> > > so no need to wait on that. The remaining patches which have been send
> > > but not yet merged are bugfixes which won't cause a collision with the
> > > short-slot patch.
> > >
> > > Not sure where I diffed it against, I probably have to rebase it anyway
> > > since I currently have a few major patches pending for the 2.1.0 release
> > > which will drastically change the entire interface handling in rt2x00.
> >
> > Ok.
> >
> > > When do you plan to send the patch for inclusion? I can rebase the patch
> > > and make it part of the 2.1.0 release of this weekend or release 2.1.0
> > > and rebase the patch against that.
> >
> > I don't know. I haven't seen anybody but You and Tomas agree with this
> > patch. I can try to convert the other drivers but I'm not sure when I'll
> > manage to do that.
>
> Ok, I'll release 2.1.0 this weekend and update the slot time patch. I'll also
> keep the patch and your slottime patch in rt2x00.git so at least rt2x00 can
> start using your patch. :)
>
> Ivo
>

Finally I got to test this but somehow I'm not getting any changed bit
set except
association one. I'm still not sure if this is problem of iwl driver or mac80211
If anybody tested please let me know

Thanks
Tomas
