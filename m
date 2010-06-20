Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38198 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0FTQaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jun 2010 12:30:14 -0400
Date: Sun, 20 Jun 2010 12:20:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/2] ssb: updates matching specs, fix for hangs?
Message-ID: <20100620162014.GB2386@tuxdriver.com>
References: <1274730624-22922-1-git-send-email-zajec5@gmail.com>
 <AANLkTilXBLwE85KLEAM2aRqdeQoO4uK2D-B_dr5Jr2pR@mail.gmail.com>
 <4C1E0C5E.7070407@hauke-m.de>
 <AANLkTilYIRMalJXji9OCerjSdZJpj45JNa8XngKB9eyC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTilYIRMalJXji9OCerjSdZJpj45JNa8XngKB9eyC@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 20, 2010 at 02:56:09PM +0200, Rafał Miłecki wrote:
> W dniu 20 czerwca 2010 14:41 użytkownik Hauke Mehrtens
> <hauke@hauke-m.de> napisał:
> > Am 20.06.2010 14:34, schrieb Rafał Miłecki:
> >> W dniu 24 maja 2010 21:50 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> >>> John, I don't really know w-t policy, so please decide where we should apply
> >>> these patches. I'll try to provide some description.
> >>
> >> John, I think you missed that two patches. It was already some time
> >> ago, but AFAIR there wasn't any reason against commiting them, am I
> >> wrong here?
> >>
> > Hi Rafał,
> >
> > They are aleardy in the wireless-next-2.6 tree and in linux-next:
> >
> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commitdiff;h=fd515941cfaf949b55086a36943afe085d7268e6
> >
> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commitdiff;h=c35deb4e70d52ed564c58569fe059dd7ca5f4eec
> 
> Whoops, OK, thanks for pointing. I just checked Linus's git and
> wireless-testing.

Must not have checked the latter too closely, since the exact same
commits are there as well... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
