Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1800 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZGEMFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 08:05:40 -0400
Date: Sun, 5 Jul 2009 08:05:15 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Hans Maes <Hans@bitnet.be>, linux-wireless@vger.kernel.org
Subject: Re: current status of 802.11s mesh in ath5k ?
Message-ID: <20090705120515.GA6329@hash.localnet>
References: <4A3B5B11.7060103@bitnet.be> <45e8e6c40906191000i2e74e06btee7313c5c30bc6a2@mail.gmail.com> <b6c5339f0906191019ve40014dp98af5ada875e2a24@mail.gmail.com> <45e8e6c40906191042k5c96d3a6wff85358da22a7b92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45e8e6c40906191042k5c96d3a6wff85358da22a7b92@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 10:42:22AM -0700, Andrey Yurovsky wrote:
> > I have been working on a patch to rework the beaconing, namely using
> > bss_conf->enable_beacon and calling beacon_config whenever the beacon
> > interval or beacon changes, that might fix it but I'm not too familiar
> > with mesh details to say.
> 
> 'looking forward to that patch.  From the driver side, there's not
> much difference between mesh beaconing and AP or IBSS beaconing. 

Can you check whether my most recent patch (I think it was 2/5 in the
ath5k series) helps?  I looked at mac80211 and it seems we set
enable_beacon properly in mesh mode so that should configure beaconing
to start.

-- 
Bob Copeland %% www.bobcopeland.com

