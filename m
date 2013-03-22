Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3CVKoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 06:44:22 -0400
Message-ID: <1363949056.8238.12.camel@jlt4.sipsolutions.net> (sfid-20130322_114426_255970_43BF527A)
Subject: Re: [PATCH] mac80211: return new mpath from mesh_path_add()
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: thomas@cozybit.com, linux-wireless@vger.kernel.org
Date: Fri, 22 Mar 2013 11:44:16 +0100
In-Reply-To: <20130321022033.GA17491@localhost> (sfid-20130321_032042_109292_4BF63A94)
References: <20130321022033.GA17491@localhost>
	 (sfid-20130321_032042_109292_4BF63A94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-20 at 22:20 -0400, Bob Copeland wrote:
> Most times that mesh_path_add() is called, it is followed by
> a lookup to get the just-added mpath.  We can instead just
> return the new mpath in the case that we allocated one (or the
> existing one if already there), so do that.  Also, reorder the
> code in mesh_path_add a bit so that we don't need to allocate
> in the pre-existing case.

This doesn't apply (on mac80211-next.)

johannes

