Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:36265 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0HBAS4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 20:18:56 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi connection problems
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	<1279917523.10769.1.camel@wwguy-huron>
	<1280135867.3693.5.camel@jlt3.sipsolutions.net>
	<87mxtd5xlq.fsf@sycorax.lbl.gov>
	<1280212629.19098.0.camel@jlt3.sipsolutions.net>
Date: Sun, 01 Aug 2010 17:18:51 -0700
In-Reply-To: <1280212629.19098.0.camel@jlt3.sipsolutions.net> (message from
	Johannes Berg on Tue, 27 Jul 2010 08:37:09 +0200)
Message-ID: <87bp9l6f4k.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2010-07-26 at 21:59 -0700, Alex Romosan wrote:
>
>> any ideas on how i can debug this? i tried to do a git-bisect but i
>> didn't get anywhere. i have the driver compiled in the kernel if that
>> makes any difference. as i played with the later kernels (after 2.6.34)
>> i discovered that if kept bringing the interface down and then up again
>> eventually i would get "cfg80211: Calling CRDA to update world
>> regulatory domain" the antenna light on the laptop (i have a thinkpad
>> t61) would go off and then at the next ifup the driver connected. looks
>> like some kind of reset/initialization problem to me.
>
> So is the issue maybe the channel the AP is no, not the fact that it's
> hidden? or something like that?

it's still not working even with kernel 2.6.35 so i decided to play with
it a little bit more. indeed, it has nothing to do with the access
point being hidden or not. it doesn't work even when it's visible
(previously i was able to connect to the wireless at work which is
visible so i wrongly assumed that was the cause).

so it looks like the problem is connecting to this particular access
point which is a proxim ap-200 orinoco wireless ap i got in 2003. right
now the ap is setup on channel 3 and the rate is set to 11 Mbps. should
i try a different channel? which one?

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
