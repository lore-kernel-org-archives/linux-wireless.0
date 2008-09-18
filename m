Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46816 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755825AbYIRUhE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:37:04 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200809162018.42576.IvDoorn@gmail.com>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221505251.4511.77.camel@localhost>
	 <1221541089.14102.44.camel@virkkmi-linux>
	 <200809162018.42576.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 20:37:00 +0000
Message-Id: <1221770220.4563.3.camel@localhost> (sfid-20080918_223709_129254_32181269)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-16 at 20:18 +0200, Ivo van Doorn wrote:
> > > Good point :-) So I suggest we have one function that adds new packets
> > > to the ACK queue (which is represented by a struct an instance of which
> > > a driver can keep in its queue information) and another one that matches
> > > a received ACK with the queue, reports the status to mac80211 and purges
> > > the queue entries up to the match (reporting them as failed).
> > > 
> > > Mikko: I could hack this up, but since your initial patch is not far
> > > from what's been discussed, I rather wait for a comment on whether you
> > > want to do it.
> > > 
> > > Mattias
> > > 
> > 
> > Feel free to hack up a patch. The functions 
> > rt2x00lib_get_match_from_ack_queue and rt2x00lib_push_to_ack_queue are
> > already generic handlers for the queue. 
> 
> Mattias, please note my comments on Mikko's patch if you are going to copy them. :)

Ok, I'm picking this thingy up. I've got some time tomorrow, but I'll be
away for the weekend, so expect something at the beginning of next week.

Mattias

