Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59857 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0GINBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 09:01:34 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Paul Fox' <pgf@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Date: Fri, 9 Jul 2010 06:01:32 -0700
Subject: RE: [PATCH] Added support for host sleep feature
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59505DA40D0D6@SC-VEXCH1.marvell.com>
In-Reply-To: <8674.1278601892@foxharp.boston.ma.us>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> amitkumar wrote:
>  > From: Amitkumar Karwar <akarwar@marvell.com>
>  >
>  > Existing "ethtool -s ethX wol X" command configures hostsleep
>  > parameters, but those are activated only during suspend/resume,
>  > there is no way to configure host sleep without actual suspend.
> 
> as background, can you expand on how this is useful?  i just spent
> a bunch of time debugging issues with HOST_SLEEP_CFG and
> HOST_SLEEP_ACTIVATE (which doesn't work on an 8388) on the XO-1
> OLPC laptop, and i'm wondering whether or how this would have
> helped.

This patch is useful if someone wants to enable host sleep feature without the device entering suspend state.

The host sleep using device suspend feature is also intact.

Thanks,
Amitkumar Karwar
