Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59746 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZDTSbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 14:31:08 -0400
Date: Mon, 20 Apr 2009 14:25:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com, me@bobcopeland.com, nbd@openwrt.org
Subject: Re: [PATCH 2/7] ath5k: Read Spur channels from EEPROM
Message-ID: <20090420182524.GE3369@tuxdriver.com> (sfid-20090420_203113_129770_F19C83A7)
References: <20090416002449.GB4138@makis> <1239841547.25334.19.camel@johannes.local> <40f31dec0904151751u3fd15d93i194d0abbb4657439@mail.gmail.com> <1239843860.4669.1.camel@johannes.local> <49E6CCBA.2010105@gmail.com> <87k55lf7hs.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k55lf7hs.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 09:16:47AM +0300, Kalle Valo wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
> 
> > On 04/16/2009 03:04 AM, Johannes Berg wrote:
> >> On Thu, 2009-04-16 at 03:51 +0300, Nick Kossifidis wrote:
> >>> ACK, are 80 cols ok ?
> >> 
> >> I don't know if there's a standard on that, I tend to use around 60-70,
> >> but 80 seems good too. It's not just the "doesn't fit terminal" argument
> >> anyway, it's much easier to read if it's less.
> >
> > When one uses git log, it gets moved few (4) columns to the right. So
> > something little less than 76 is usually preferred :).
> 
> I think in usenet 72 characters was the recommended width, right? That
> way quoting was also easier.

72 is my vote...thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
