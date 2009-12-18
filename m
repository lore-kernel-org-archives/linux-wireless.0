Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26576 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbZLRRUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 12:20:42 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 09:20:42 -0800
Date: Fri, 18 Dec 2009 09:20:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?utf-8?B?THVrw6HFoQ==?= Turek <8an@praha12.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute
 COVERAGE_CLASS
Message-ID: <20091218172040.GF6231@tux>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
 <200912152352.45977.8an@praha12.net>
 <43e72e890912160030p3bbca486x817d3454fa9ebd62@mail.gmail.com>
 <200912181733.52413.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <200912181733.52413.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 18, 2009 at 08:33:52AM -0800, Lukáš Turek wrote:
> On 16.12.2009 09:30 you wrote:
> > Thanks a lot for your work on this!
> I thank you too for the comments, but, what do I have to do to get an ACK, 
> besides the trivial fixes like the drv_ wrapper and moving the ah_coverage 
> setting?

Resend and add v2 to the patch prefix "--subject-prefix="PATCH v2" IIRC
on git format-patch.

  Luis
