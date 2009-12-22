Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2533 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZLVDbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 22:31:43 -0500
Date: Mon, 21 Dec 2009 22:28:48 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Luk???? Turek <8an@praha12.net>
Cc: ???????????? <tkaiso@thinktube.com>, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to
	usec  conversion
Message-ID: <20091222032848.GA4146@hash.localnet>
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <200912211340.51229.8an@praha12.net> <b6c5339f0912210708wa538055s74a7054eef0e77b6@mail.gmail.com> <200912211628.39169.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200912211628.39169.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2009 at 04:28:35PM +0100, Luk???? Turek wrote:
> On 21.12.2009 16:08 Bob Copeland wrote:
> If performance mattered, we could store the mode index somwhere. But it 
> doesn't, the conversion is only needed when setting ACK timeout and slot 
> time - which is, for most users, never done and defaults from initvals.c are 
> used instead.

Agreed.  Feel free to add my

Acked-by: Bob Copeland <me@bobcopeland.com>

to that patch.

-- 
Bob Copeland %% www.bobcopeland.com

