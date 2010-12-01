Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab0LAVDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:03:11 -0500
Message-Id: <20101201205939.009530439@sipsolutions.net>
Date: Wed, 01 Dec 2010 21:59:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org
Subject: [RFC 0/5] mesh join/leave API
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm heading to bed ... so the TTL thing will
have to be figured out later. I've also not
tested this at all, maybe you can :-)

Basically the idea is to decouple the state
of mesh from interface UP/DOWN and add new
commands to join/leave.

Then the beacon configuration can be part of
join -- I suppose things that can change on
the fly will be part of the mesh_config, and
things that can't will become part of a new
mesh_setup struct or so ... This way there's
no need for new commands or such, just add
new attributes to the join command...

Anyway, just an implementation of the ideas
I was toying with.

johannes

