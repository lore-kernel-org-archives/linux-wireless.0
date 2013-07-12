Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab3GLICQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 04:02:16 -0400
Message-ID: <1373616129.8205.2.camel@jlt4.sipsolutions.net> (sfid-20130712_100233_296953_3C6AE61C)
Subject: Re: interested in py80211?
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 12 Jul 2013 10:02:09 +0200
In-Reply-To: <51D49027.9010803@broadcom.com> (sfid-20130703_225725_898124_EAB997AB)
References: <51D49027.9010803@broadcom.com>
	 (sfid-20130703_225725_898124_EAB997AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yep, I'd totally be interested. Not that I don't have enough things on
my plate already ;-)

On Wed, 2013-07-03 at 22:57 +0200, Arend van Spriel wrote:
> A common say in Linux arena is "when you have an itch, just scratch it".

:-)

> My itch is that tools like ifconfig and iw are great, but in an 
> automated test environment it kind of sucks to parse output, which is 
> confirmed by blurb from iw: "Do NOT screenscrape this tool, we don't 
> consider its output stable.".

Heh, yeah ...

> Ever since my first contact with Python I tend to favor it over other 
> scripting alternatives so I decided to scratch my itch with that and 
> another old acquaintance called SWIG. With those I went to create 
> py80211. A first attempt was to have SWIG create a wrapper API directly 
> exposing the libnl-3 API, but that did not feel comfortable in a 
> scripting environment. So the level of abstraction is a bit higher. It 
> is just in a kick-off state (eg. can only send u32 attributes), but I 
> decided to push it to github anyway.

Another approach might be exposing the libnl APIs and then build a
higher-level library in python. Have you considered that? That might
make it useful to other users of netlink as well, while keeping a 'nice'
nl80211 API?

johannes

