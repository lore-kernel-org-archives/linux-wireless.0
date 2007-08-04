Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:45949 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbXHDHyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 03:54:06 -0400
Message-ID: <46B4309A.70804@warmcat.com>
Date: Sat, 04 Aug 2007 08:54:02 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: further plan wrt. monitor interfaces
References: <1186178959.13315.30.camel@johannes.berg>
In-Reply-To: <1186178959.13315.30.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> After my recent patch drivers can now tell the stack that a frame was
> damaged. That doesn't do much good, however, if the user cannot tell the
> stack to generate such frames. But we need to go level by level so first
> mac80211 needs to know about it.
> 
> After some discussion and review of Daniel's document (thanks!) we came
> up with the following ideas:

I don't know enough abut the insides of the drivers and stack to have
any useful opinion on the details of the implementation as Ulrich has.

Definitely the additional functionality and the granularity of the
filtering that can eventually be requested (if not delivered on by any
particular driver) will be really nice.  Throwing out the soft Monitor
mode but being able to emulate that and more with the new range of
selections is great.  As is making selectability of broken packets
official, eventually.

-Andy
