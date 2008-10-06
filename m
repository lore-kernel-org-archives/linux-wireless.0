Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2084 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYJFOjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 10:39:12 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Elias Oltmanns <eo@nebensachen.de>, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Date: Mon, 6 Oct 2008 10:36:39 -0400
Message-Id: <20081006143055.M60271@bobcopeland.com> (sfid-20081006_163917_389277_9AAEF440)
In-Reply-To: <1223302987.15196.24.camel@johannes.berg>
References: <200808101401.03339.toralf.foerster@gmx.de> <87od23mo08.fsf@denkblock.local> <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com> <20081002144600.M31352@bobcopeland.com> <87bpy32c1w.fsf@denkblock.local> <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com> <20081003134648.M45120@bobcopeland.com> <87fxnd2112.fsf@denkblock.local> <20081003193739.M19356@bobcopeland.com> <877i8nky65.fsf@denkblock.local> <b6c5339f0810060712r24b0dfd8s6236e65304749572@mail.gmail.com> (sfid-20081006_161241_841588_FA70583E) <1223302987.15196.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 06 Oct 2008 16:23:07 +0200, Johannes Berg wrote
> On Mon, 2008-10-06 at 10:12 -0400, Bob Copeland wrote:
> 
> > Nonetheless, I admit not being expert in this area, nor do I know if relying
> > on the freezer is acceptable, so someone more clueful, please chime in.
> 
> It's not, it's supposed to be removed.

Great, thanks for that info.

> However, I still think ath5k shouldn't be much concerned with all this
> because mac80211 should just disable all interfaces etc. from it when
> suspending.

Agreed.  I guess if no one else gets to it by then, I can take a look at it in
a couple of weeks after my GRE.

-- 
Bob Copeland %% www.bobcopeland.com


