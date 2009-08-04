Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57430 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933403AbZHDWEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:04:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [PATCH] remove wrong probe_resp_plcp write
Date: Wed, 5 Aug 2009 00:04:05 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0907311335h3065547aqc736573a663b6d42@mail.gmail.com> <1249417983.24787.8.camel@johannes.local> <83a869cd0908041458n1f23f100pee5a6b3c4c3f11e4@mail.gmail.com>
In-Reply-To: <83a869cd0908041458n1f23f100pee5a6b3c4c3f11e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908050004.05429.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 August 2009 23:58:45 gregor kowski wrote:
> On 8/4/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2009-08-04 at 22:27 +0200, Michael Buesch wrote:
> >
> > Just remove it -- if we need it back we can find it in the git archives,
> > and it's rather unlikely that we're going to add that functionality to
> > mac80211 and hostapd unless you'll push it.
> >
> What should be removed ?
> b43_write_probe_resp_template and b43_write_probe_resp_plcp ?

yes

-- 
Greetings, Michael.
