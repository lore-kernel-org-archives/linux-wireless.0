Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3JGHlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 03:41:04 -0400
Message-ID: <1381131658.13586.0.camel@jlt4.sipsolutions.net> (sfid-20131007_094107_889690_41CFBFEF)
Subject: Re: NetworkManager not listing access points
From: Johannes Berg <johannes@sipsolutions.net>
To: Detlev Casanova <detlev.casanova@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Date: Mon, 07 Oct 2013 09:40:58 +0200
In-Reply-To: <2916718.7t7kLXuBQV@naboo> (sfid-20131007_084842_017679_F9EA17BB)
References: <31357461.i5mG9q5IfA@naboo> <3913713.WUui18VufC@naboo>
	 <1380704936.13329.14.camel@jlt4.sipsolutions.net>
	 <2916718.7t7kLXuBQV@naboo> (sfid-20131007_084842_017679_F9EA17BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-07 at 08:48 +0200, Detlev Casanova wrote:

> > > Yes and the problem is most likely to be in the driver because it
> doesn't
> > > occur before commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8
> ("cfg80211:
> > > use DS or HT operation IEs to determine BSS channel")

[...]

> I looked into wpa_supplicant and after an upgrade from 0.7.3 to 2.0,
> the problem seems to be fixed.

Huh, that's odd. Did 0.7.3 use wext driver?

johannes

