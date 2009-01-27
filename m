Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:3536 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZA0DRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 22:17:33 -0500
Message-ID: <497E7CBC.7000607@canonical.com> (sfid-20090127_041737_495380_6E0A4FD7)
Date: Mon, 26 Jan 2009 20:17:16 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: mcgrof@tmo.blackberry.net,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: CRDA and wireless-regdb packaging
References: <43e72e890901231546y68635a9foead5bf2003ae16f5@mail.gmail.com>
In-Reply-To: <43e72e890901231546y68635a9foead5bf2003ae16f5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Hey Tim
> 
> I have searched for CRDA on -proposed on jaunty and don't see it yet.
> I searched the net and found your PPA and your packages so I gave
> wireless-crda a shot but I noticed it doesn't install crda, only
> documentation, perhaps I'm not looking in the right place. Anyway
> since debian didn't have a package, and I then noticed some issues
> with the wireless-regdb package I installed and I really wish crda and
> wireless-regdb is separated I didn't want to bug you about it as I
> know you have your plate full and decided to just give packaging them
> a shot.
> 
> I've separated into two packages:
> 
> crda
> wireless-regdb
> 
> This allows regulatory updates to be completely separate from crda.
> I've also added man pages for wireless-regdb and crda stuff. The
> packages I built use cdbs which make the debian/rules short and sweet.
> I sent the stuff to John as a patch under debian-example. I've also
> put my own stuff under crda's debian-example.
> 
>   Luis
> --

Luis - I'm still working on CRDA as time allows, but I promise I'll git
'er done in time. I did find the packaging problem you mentioned, thanks
for spotting that.

I hope to write the 'Main Inclusion Request' for CRDA tomorrow after
exploring some policy issues with my archive admins. I'll also be
rubbing elbows with them next week in Berlin, so should be able to get
CRDA included by then.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
