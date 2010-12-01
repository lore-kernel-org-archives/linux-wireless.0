Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab0LATfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 14:35:55 -0500
Subject: Re: [PATCH] mac80211: Support beacon configuration via nl80211 for
 mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1291229642.4199.11.camel@jlt3.sipsolutions.net>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com>
	 <1291184383.4199.4.camel@jlt3.sipsolutions.net>
	 <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
	 <1291229642.4199.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 20:35:51 +0100
Message-ID: <1291232151.4199.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 19:54 +0100, Johannes Berg wrote:

> If we had a 'start mesh' command, like 'join IBSS', then it'd be natural
> to have just more attributes in it. Maybe it's time to start thinking
> about that again, although backward compatibility could be interesting.

Ok I started looking at this ...

I have a feeling I asked this before, but can't remember -- is it
necessary to be able to change the mesh config on the fly, while the
mesh is active?

johannes

