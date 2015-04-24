Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45496 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbbDXOnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 10:43:09 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21818.22087.358832.866965@gargle.gargle.HOWL> (sfid-20150424_164314_103432_7B036739)
Date: Fri, 24 Apr 2015 20:12:15 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k to ath9k IBSS, ath9k has interface-combinations issue
In-Reply-To: <55304F9D.1060301@candelatech.com>
References: <5523273F.4060803@candelatech.com>
	<CA+BoTQ=UUbfi5D9ZbN5Rxb20f5xpzuYQMo392=P++Qyhz8Hs+w@mail.gmail.com>
	<CALhHN=oCvQ=SvobWTvc3geK-66k2+YDzB1HqSguCxTeV0QzWwg@mail.gmail.com>
	<552406E4.50600@candelatech.com>
	<55241567.3010703@candelatech.com>
	<21796.40851.132919.363957@gargle.gargle.HOWL>
	<55304F9D.1060301@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> > TSF would jump around since the HW would sync with the
> > received beacons and this will happen in both IBSS and station
> > mode. Hence the limitation, but I think OpenWrt has a one-liner
> > to remove this restriction...
> 
> It seems I can only do a single VAP on ath9k as well?
> 
> Is that per design?

I was referring to ath9k, but it probably applies to ath10k too.
But yes, IBSS is restricted to a single interface by design.

Sujith
