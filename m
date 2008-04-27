Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:48375 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYD0VdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 17:33:06 -0400
Received: by an-out-0708.google.com with SMTP id d31so1149360and.103
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2008 14:33:05 -0700 (PDT)
Message-ID: <43e72e890804271433j9f81c22p249a2eb239d07d08@mail.gmail.com> (sfid-20080427_233319_277883_FED52583)
Date: Sun, 27 Apr 2008 14:33:05 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: w35und: one more unneccessary function
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080427181336.GB493@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080419194206.GA17558@elf.ucw.cz>
	 <43e72e890804252208g2d19acedh1ceff3aa209489ad@mail.gmail.com>
	 <20080427181336.GB493@elf.ucw.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 27, 2008 at 11:13 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>
>
>  > > Remove one more unnecessary function.
>  > >
>  > >  ---
>  > >  commit 8cf2b466620bd533acf20596be1fabfc0b46d992
>  > >  tree e0bf7b039e545bede22980048669557fc49490e4
>  > >  parent 6627ff26a459db3e792ec4dc194122c133c150a5
>  > >  author Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 21:41:31 +0200
>  > >  committer Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 21:41:31 +0200
>  > >
>  > >   .../net/wireless/winbond/winbondport/mlmetxrx.c    |   57 -----------------------
>  > >   1 files changed, 0 insertions(+), 57 deletions(-)
>  > >
>  > >  diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
>  > >  index dcfdfd4..f58e458 100644
>  > >  --- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
>  > >  +++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
>  >
>  > drivers/net/wireless/winbond/ ? What tree is this in?
>
>  My tree :-). It should be in some branch at code.google, too, and I
>  can do a full diff against vanilla if there's interest.

Cool :) You seem to have quite a few trees. Which tree is it on? What
is the winbond driver? I guess I also don't understand the diffs
against your own tree on this list if we don't have much info for this
winbond driver or if its not merged yet. Is there a project link where
we can read a bit more about this driver and hardware it supports?

  Luis
