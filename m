Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:50408 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1GWIzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 04:55:04 -0400
Date: Sat, 23 Jul 2011 10:54:58 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] ssb: define boardflags
Message-ID: <20110723105458.61ed2073@maggie> (sfid-20110723_105509_016628_E03A31E2)
In-Reply-To: <CACna6rxZqmC-n1iQGX+KnoPDFRx4gY1gV+td0gPi2wu_WnT1XQ@mail.gmail.com>
References: <1311412213-3825-1-git-send-email-zajec5@gmail.com>
	<1311412213-3825-2-git-send-email-zajec5@gmail.com>
	<20110723103725.6d5bab09@maggie>
	<CACna6rxZqmC-n1iQGX+KnoPDFRx4gY1gV+td0gPi2wu_WnT1XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 23 Jul 2011 10:49:55 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> W dniu 23 lipca 2011 10:37 użytkownik Michael Büsch <m@bues.ch> napisał:
> > On Sat, 23 Jul 2011 11:10:11 +0200
> > Rafał Miłecki <zajec5@gmail.com> wrote:
> >
> >> They are SPROM specific, so all should be defined in ssb code.
> >
> > Oh, well. I'm not sure.
> > Most of these currently are defined in b43 code, because they are b43-specific
> > and _not_ ssb specific. If we decide to define them in ssb, they need to be
> > removed from b43, at least.
> 
> Well, SPROM is board specific (not 80211 core specific), so I believe
> the same applies to boardflags, doesn't it? Boardflags are read from
> SPROM, so it makes sense for me.

No. Most of these flags are specific to the whole device (the board).
Most flags are invalid or have another meaning for b44, for instance.

-- 
Greetings, Michael.
