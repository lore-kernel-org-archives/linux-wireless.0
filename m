Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from v5897.vanager.de ([88.80.221.133]:58291 "EHLO v5897.vanager.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083AbZKRTle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 14:41:34 -0500
Date: Wed, 18 Nov 2009 20:31:56 +0100
From: Florian Engelhardt <flo@dotbox.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] "iwlist scan" shows same ap twice
Message-ID: <20091118203156.693fc488@dotbox.org>
In-Reply-To: <43e72e890911181118o416145ach6b7140341cb6dfc5@mail.gmail.com>
References: <b0c954732ea30effda967bd97ef30597@127.0.0.1>
	<43e72e890911171335n3193b63foa6f473ceb659f3ab@mail.gmail.com>
	<a563a2d5dfdbca955cbac7a65790f443@127.0.0.1>
	<43e72e890911181118o416145ach6b7140341cb6dfc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 18 Nov 2009 11:18:01 -0800
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> On Wed, Nov 18, 2009 at 11:09 AM, Florian Engelhardt <flo@dotbox.org>
> wrote:
> > On Tue, 17 Nov 2009 13:35:24 -0800, "Luis R. Rodriguez"
> > <mcgrof@gmail.com> wrote:
> >
> >> That's wild. What kernel are you using?
> >
> > # uname -a
> > Linux eka 2.6.31-ARCH #1 SMP PREEMPT Tue Nov 10 19:48:17 CET 2009
> > i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
> >
> >> Have you tried:
> >> http://wireless.kernel.org/en/users/Download/stable
> >> or
> >> http://wireless.kernel.org/en/users/Download
> >
> > Tried both, no change.
> >
> >> Can you provide the output of 'iw list', your dmesg, and your 'iw
> >> dev wlan0 scan'.
> >
> > See attached files. Despite that i can add one additional
> > information: I have a second Laptop with Intel WLAN Chip, and it
> > shows exactly the same behaviour, MA-WLAN two, sometimes three
> > times, with none of the addresses being correct.
> >
> > Somehow, i can not reproduce this kind of behaviour with my own
> > wlan. It shows up only one time, not multiple, but it did two days
> > ago on the ath5k chipset based netbook
> 
> As Bob pointed out your scan shows two beacons received on different
> BSSes:
> 
> 00:80:48:5c:86:5d
> 00:80:48:5c:86:48
> 
> The TSF on the second one seems odd though. Do you have access to the
> AP? Can you change the channel to see if you see the two beacons on a
> new channel?
> Can you try rebooting it?

Sorry, no. I have no access to that AP, but i can ask the owner if he
may reboot it, or if he faces any problems with it.

/Florian
