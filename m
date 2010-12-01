Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48847 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab0LAUTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 15:19:13 -0500
Subject: Re: [PATCH] mac80211: Support beacon configuration via nl80211 for
 mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimgfRvqp=-CDU=G8o-ZfD4fVbf3j-AdXCVtoM6c@mail.gmail.com>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com>
	 <1291184383.4199.4.camel@jlt3.sipsolutions.net>
	 <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
	 <1291229642.4199.11.camel@jlt3.sipsolutions.net>
	 <1291232151.4199.12.camel@jlt3.sipsolutions.net>
	 <AANLkTimgfRvqp=-CDU=G8o-ZfD4fVbf3j-AdXCVtoM6c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 21:19:11 +0100
Message-ID: <1291234751.4199.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 12:09 -0800, Javier Cardona wrote:

> It is convenient to be able to change things like the ttl or the auto
> peering without having to bring down the interface.  People might also
> want to tune from userspace the different mesh timeouts in response to
> changes in operating conditions (e.g. mesh density).

Makes sense.

> But right now the only parameter that needs the mesh to be active is
> plink_action:  one can only block or manually initiate peering after a
> beacon has been received from a suitable neighbor.

It looks like one can modify the mesh ID on the fly right now -- that
I'm going to remove, the other things can stay for all I care :-)

johannes

