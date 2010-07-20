Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4085 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab0GTLUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 07:20:04 -0400
Date: Tue, 20 Jul 2010 07:20:41 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: ath5k Ad Hoc Association
Message-ID: <20100720112041.GA7049@hash.localnet>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com> <AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com> <AANLkTimgt_HdXyGneQMOz7wR7Xs7BBrDUCGoxP1qDcYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimgt_HdXyGneQMOz7wR7Xs7BBrDUCGoxP1qDcYg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[please don't top post]
On Tue, Jul 20, 2010 at 04:39:29PM +1000, Jonathan Guerin wrote:
> Yes, I've checked the channel (36, 5180) allows beaconing. I've tried
> the commands you mentioned, but no luck. If I monitor the interface
> from another station, the ath5k drive never appears to beacon.

What does "iw phy phy0 info" show?

-- 
Bob Copeland %% www.bobcopeland.com

