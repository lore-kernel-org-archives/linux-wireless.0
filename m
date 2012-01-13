Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44388 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab2AMTbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 14:31:09 -0500
Date: Fri, 13 Jan 2012 14:20:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: add default option to avoid duplicating device
 support with brcmsmac
Message-ID: <20120113192027.GE18899@tuxdriver.com> (sfid-20120113_203114_328875_031CA8CA)
References: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
 <CACna6rxffpPhYVqKNttu79JET=NkBP4NrAayywQHWcj=mw=T9A@mail.gmail.com>
 <CAGRGNgUkBUvoBJydcdprBXP0ufR+PQ6nXFXdW546xjHbQ-O2Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGRGNgUkBUvoBJydcdprBXP0ufR+PQ6nXFXdW546xjHbQ-O2Bg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 13, 2012 at 01:07:03PM +1100, Julian Calaby wrote:
> 2012/1/13 Rafał Miłecki <zajec5@gmail.com>:
> > 2012/1/11 John W. Linville <linville@tuxdriver.com>:
> >> +config B43_BCMA_EXTRA
> >> +       bool "Support for devices also supported by brcmsmac"
> >> +       depends on B43_BCMA
> >> +       default n
> >> +
> >
> > Is this really *the* solution? I wonder if we can do whatever you're
> > trying to do in a better way? To let final users try both drivers
> > without recompiling kernel?
> 
> Another issue is that this should arguably be default y if brcmsmac is disabled.

Can you help by suggesting the correct Kconfig magic to implement that?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
