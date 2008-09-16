Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:31554 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbYIPSSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:18:47 -0400
Received: by ik-out-1112.google.com with SMTP id c30so2519004ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 11:18:45 -0700 (PDT)
To: Mikko =?iso-8859-15?q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
Date: Tue, 16 Sep 2008 20:18:42 +0200
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1221494693.14102.22.camel@virkkmi-linux> <1221505251.4511.77.camel@localhost> <1221541089.14102.44.camel@virkkmi-linux>
In-Reply-To: <1221541089.14102.44.camel@virkkmi-linux>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809162018.42576.IvDoorn@gmail.com> (sfid-20080916_201851_069237_C9F741C4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Good point :-) So I suggest we have one function that adds new packets
> > to the ACK queue (which is represented by a struct an instance of which
> > a driver can keep in its queue information) and another one that matches
> > a received ACK with the queue, reports the status to mac80211 and purges
> > the queue entries up to the match (reporting them as failed).
> > 
> > Mikko: I could hack this up, but since your initial patch is not far
> > from what's been discussed, I rather wait for a comment on whether you
> > want to do it.
> > 
> > Mattias
> > 
> 
> Feel free to hack up a patch. The functions 
> rt2x00lib_get_match_from_ack_queue and rt2x00lib_push_to_ack_queue are
> already generic handlers for the queue. 

Mattias, please note my comments on Mikko's patch if you are going to copy them. :)

Ivo
