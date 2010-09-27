Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60267 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0I0POh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 11:14:37 -0400
Date: Mon, 27 Sep 2010 11:02:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rebased version of wireless-testing?
Message-ID: <20100927150235.GB11086@tuxdriver.com>
References: <4C9CFD86.2080207@candelatech.com>
 <20100924200532.GH8077@tuxdriver.com>
 <4C9D14B6.70206@candelatech.com>
 <20100925134325.GD1948@tuxdriver.com>
 <4C9E1C5D.4020805@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C9E1C5D.4020805@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 25, 2010 at 08:59:25AM -0700, Ben Greear wrote:
> On 09/25/2010 06:43 AM, John W. Linville wrote:
> >On Fri, Sep 24, 2010 at 02:14:30PM -0700, Ben Greear wrote:
> >
> >>>You will be better-off pulling wireless-next-2.6 (and maybe
> >>>wireless-2.6 as well).  The history there isn't always immutable
> >>>(although I prefer it to be), but it will tend to be a lot cleaner
> >>>than wireless-testing.
> >>
> >>Any chance you could push tags in wireless-next-2.6?
> >
> >Not sure what you mean -- are you not seeing the master-<date>  tags?
> 
> It didn't seem like the 2.6.36-rcX tags were there..but then again, maybe
> I'm looking for something that doesn't exist?

Ah...well, they probably won't be in there until after 2.6.36 is
released.  I generally don't pull from Linus into that tree during
the release cycle in order to avoid surprising Dave when he pulls it.
But if you are basing on linux-2.6 then you should already have those
tags anyway?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
