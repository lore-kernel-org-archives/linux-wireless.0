Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46636 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776AbcASUoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 15:44:55 -0500
Message-ID: <1453236291.25499.0.camel@sipsolutions.net> (sfid-20160119_214518_560198_153E951F)
Subject: Re: [PATCH 5/8] rfkill: Remove obsolete "state" sysfs interface
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>, linux@endlessm.com
Date: Tue, 19 Jan 2016 21:44:51 +0100
In-Reply-To: <CA+A7VXVOYY4vzYupsoG0A9kinBvRhrD3_MP2DByR5v+5gGYuyA@mail.gmail.com> (sfid-20160119_213710_142942_A54A4B35)
References: <1453218163-31998-1-git-send-email-jprvita@endlessm.com>
	 <1453218163-31998-6-git-send-email-jprvita@endlessm.com>
	 <1453234505.23600.6.camel@sipsolutions.net>
	 <CA+A7VXVOYY4vzYupsoG0A9kinBvRhrD3_MP2DByR5v+5gGYuyA@mail.gmail.com>
	 (sfid-20160119_213710_142942_A54A4B35)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-19 at 15:36 -0500, João Paulo Rechi Vita wrote:
> 
> > I suspect that nevertheless, we can't just remove it - Googling
> > around shows quite a bit of (e.g. Android) code using it.
> > 
> 
> Should I update the expected removal date to 2018, or some other time
> in the future? Or if this is not going to be removed at all,
> shouldn't it be moved back to stable?
> 

Yeah, maybe we should just move it back. The problem with it is that it
doesn't fully reflect the state (both sw+hw blocked can't be reflected)
but if the current users are happy with it then that's not really a
problem.

johannes
