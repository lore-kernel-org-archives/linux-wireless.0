Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:44593 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756879Ab0JDSpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:45:00 -0400
Date: Mon, 4 Oct 2010 20:44:58 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	justinmattock@gmail.com, Bob Copeland <me@bobcopeland.com>,
	Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.36-rc6-git2: Reported regressions from 2.6.35
Message-ID: <20101004184458.GA18119@isilmar-3.linta.de>
References: <-jYMINoCtaK.A.F5.8CPqMB@chimera> <AANLkTimUdaUkpXmNt5mPkCdWmHvBbXWA6smAP4U80yc4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTimUdaUkpXmNt5mPkCdWmHvBbXWA6smAP4U80yc4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

On Mon, Oct 04, 2010 at 11:35:25AM -0700, Luis R. Rodriguez wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=17061
> > Subject         : 2.6.36-rc1 on zaurus: bluetooth regression
> > Submitter       : Pavel Machek <pavel@ucw.cz>
> > Date            : 2010-08-21 15:24 (44 days old)
> > Message-ID      : <20100821152445.GA1536@ucw.cz>
> > References      : http://marc.info/?l=linux-kernel&m=128240433828087&w=2
> 
> I see no updates to this since August. There are boat load of PCMCIA
> changes recently, is bisect possible here?

Pavel already verified the PCMCIA-bigdiff since 2.6.35 does work, so it is
_not_ a PCMCIA issue.

http://www.mail-archive.com/linux-pcmcia@lists.infradead.org/msg03460.html

Best,
	Dominik
