Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIQWEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 18:04:22 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Davide Pesavento <davidepesa@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910809171458q70763189lde2e2710c64fc70c@mail.gmail.com> (sfid-20080917_235842_452286_EE2E63D1)
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221648205.9262.48.camel@johannes.berg> <48D0E463.70008@le-vert.net>
	 <1221649638.9262.50.camel@johannes.berg> <48D0E5CE.8050401@le-vert.net>
	 <1221650286.9262.57.camel@johannes.berg>
	 <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com>
	 <1221683467.7412.6.camel@localhost>
	 <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com>
	 <1221688366.7412.13.camel@localhost>
	 <69e28c910809171458q70763189lde2e2710c64fc70c@mail.gmail.com>
	 (sfid-20080917_235842_452286_EE2E63D1)
Content-Type: text/plain; charset=utf-8
Date: Thu, 18 Sep 2008 00:04:12 +0200
Message-Id: <1221689052.7412.18.camel@localhost> (sfid-20080918_000424_360280_A664439B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-17 at 23:58 +0200, Stefanik G=C3=A1bor wrote:

> IMO that's the best thing to do - in fact, that's exactly why I
> branched.=20

It's not a good thing to do at all, in fact, it would be a possible
compromise only if I'd be willing to maintain that, which I've decided
against, it's another step to take when adding a new command, and it's
not hard to copy in a header file and patch iw.

>  (This is likely why Debian is
> shipping my branched version, rather than the official.)

I think you're deluded. If you'd read the bug report it's because they
didn't know better and nobody told them.

johannes

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
