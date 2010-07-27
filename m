Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0G0UKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 16:10:13 -0400
Subject: Re: [PATCH] mac80211: fix sw scan bracketing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikFjgzL1DOfUVS_N_=p5N3r0Qp7VoC5+-9cbb1a@mail.gmail.com>
References: <1276857140.3638.22.camel@jlt3.sipsolutions.net>
	 <AANLkTinHXxhwrOmhRxveekG7_C7WeydUdSBL2R7DwOvJ@mail.gmail.com>
	 <AANLkTinch-sygnRmB6LKi6xLNYVKY6Ap3YL4_PMNdmKQ@mail.gmail.com>
	 <AANLkTik=1LX_12ZskP5vwkSrTVFO9jH6uu8pyByGmLg6@mail.gmail.com>
	 <1280226169.19098.12.camel@jlt3.sipsolutions.net>
	 <AANLkTi=ZbskS-7TA8Mp5SKrRMrxOpNQJLpxnCHoRs-tb@mail.gmail.com>
	 <AANLkTikFjgzL1DOfUVS_N_=p5N3r0Qp7VoC5+-9cbb1a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 22:09:56 +0200
Message-ID: <1280261396.3755.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-27 at 10:29 -0700, Luis R. Rodriguez wrote:

> I just reviewed this and noticed both of these prints are using
> KERN_DEBUG, and since the warning will become valid *after* this gets
> properly fixed, are you OK with just a revert of your patch?

I've seen this show up in bug reports, and we _know_ that there's a
problem since I fixed it, so no, I really do want the message to go
away.

johannes

