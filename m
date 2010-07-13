Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33569 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0GMIdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 04:33:47 -0400
Received: by wwi17 with SMTP id 17so755694wwi.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jul 2010 01:33:46 -0700 (PDT)
Subject: RE: [PATCH] Added support for host sleep feature
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: 'Paul Fox' <pgf@laptop.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF59505DA40D0D6@SC-VEXCH1.marvell.com>
References: <5FF020A1CFFEEC49BD1E09530C4FF59505DA40D0D6@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 10:33:42 +0200
Message-ID: <1279010022.3164.27.camel@realization>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On ven, 2010-07-09 at 06:01 -0700, Amitkumar Karwar wrote:
> 
> > amitkumar wrote:
> >  > From: Amitkumar Karwar <akarwar@marvell.com>
> >  >
> >  > Existing "ethtool -s ethX wol X" command configures hostsleep
> >  > parameters, but those are activated only during suspend/resume,
> >  > there is no way to configure host sleep without actual suspend.
> > 
> > as background, can you expand on how this is useful?  i just spent
> > a bunch of time debugging issues with HOST_SLEEP_CFG and
> > HOST_SLEEP_ACTIVATE (which doesn't work on an 8388) on the XO-1
> > OLPC laptop, and i'm wondering whether or how this would have
> > helped.
> 
> This patch is useful if someone wants to enable host sleep feature without the device entering suspend state.
> 
> The host sleep using device suspend feature is also intact.
> 
> Thanks,
> Amitkumar Karwar

Regards current consumption, maintaining a wireless connection active,
the device consumes circa 30 mA instead of 180 mA of full power idle
mode.
So for embedded devices powered from battery, enabling the Power Save
mode is a huge battery save task.

Best Regards,

-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

