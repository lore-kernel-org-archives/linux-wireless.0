Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44291 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796AbYD0SMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 14:12:55 -0400
Date: Sun, 27 Apr 2008 20:13:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: w35und: one more unneccessary function
Message-ID: <20080427181336.GB493@elf.ucw.cz> (sfid-20080427_201308_185239_0482B191)
References: <20080419194206.GA17558@elf.ucw.cz> <43e72e890804252208g2d19acedh1ceff3aa209489ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890804252208g2d19acedh1ceff3aa209489ad@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> > Remove one more unnecessary function.
> >
> >  ---
> >  commit 8cf2b466620bd533acf20596be1fabfc0b46d992
> >  tree e0bf7b039e545bede22980048669557fc49490e4
> >  parent 6627ff26a459db3e792ec4dc194122c133c150a5
> >  author Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 21:41:31 +0200
> >  committer Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 21:41:31 +0200
> >
> >   .../net/wireless/winbond/winbondport/mlmetxrx.c    |   57 -----------------------
> >   1 files changed, 0 insertions(+), 57 deletions(-)
> >
> >  diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
> >  index dcfdfd4..f58e458 100644
> >  --- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
> >  +++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
> 
> drivers/net/wireless/winbond/ ? What tree is this in?

My tree :-). It should be in some branch at code.google, too, and I
can do a full diff against vanilla if there's interest.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
