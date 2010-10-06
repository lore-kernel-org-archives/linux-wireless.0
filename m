Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45751 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0JFUaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 16:30:10 -0400
Date: Wed, 6 Oct 2010 16:18:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 3/3] b43: N-PHY: don't duplicate setting channel in
 shared memory
Message-ID: <20101006201850.GK2472@tuxdriver.com>
References: <1286344208-32479-1-git-send-email-zajec5@gmail.com>
 <1286344208-32479-4-git-send-email-zajec5@gmail.com>
 <1286379040.11721.1.camel@maggie>
 <AANLkTinsWTCmTjYZ=SgY0-ArTOVgG50V0r9USHnuvQfb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTinsWTCmTjYZ=SgY0-ArTOVgG50V0r9USHnuvQfb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 06, 2010 at 06:07:44PM +0200, Rafał Miłecki wrote:
> W dniu 6 października 2010 17:30 użytkownik Michael Büsch
> <mb@bu3sch.de> napisał:
> > On Wed, 2010-10-06 at 07:50 +0200, Rafał Miłecki wrote:

> >> +     /* Don't follow specs, B43_SHM_SH_CHAN is set by b43_switch_channel */
> >
> > Looks great. I dunno if a comment is really needed and whether it is
> > correct, though. We _do_ follow the specs. We just do it elsewhere.
> 
> I got "Don't strictly follow specs here" earlier, but made it shorter
> to match 80 chars ;) Maybe it wasn't too good idea. Should left it
> longer or don't put at all.
> 
> John: could you drop this comment line when applying? Or would you
> like me to resend this fixed?

Got it...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
