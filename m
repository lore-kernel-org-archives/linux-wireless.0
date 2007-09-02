Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sibelius.xs4all.nl ([82.92.89.47]:40827 "EHLO
	brahms.sibelius.xs4all.nl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932905AbXIBOLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2007 10:11:36 -0400
Date: Sun, 2 Sep 2007 15:42:51 +0200 (CEST)
Message-Id: <200709021342.l82DgpP4029155@brahms.sibelius.xs4all.nl>
From: Mark Kettenis <mark.kettenis@xs4all.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k - License clarification
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: "Luis R. Rodriguez"
> Date: 2007-08-31 16:18:37
>
> Attached patch amends the ath5k license as per review from SFLC with
> the following changes:
> 
>  * Makes sure that Reyk's copyright and license notice appears
>    correctly in each file that was derived from his work.
>
>  * Makes sure that Jiri's changes were released under a permissive,
>    modified-BSD license, as he indicated that was his preference.

Thanks Jiri, for respecting the wishes of the origional author of this
code.

>  * Makes sure that Nick's changes were released under
>    GPLv2-or-later, as he indicated that was his preference.

No kudo's to Nick here.  I assume you realize that by doing this
you're effectively saying to the *BSD developers something "Thank you
for all the work you've done on this driver, but you can't have any of
my changes anymore".  I think it's rather unlikely that that'll go
down well, and I doubt they'll be eager to work with you in the future.

To all other (potential) Linux wirless driver devlopers I'd like to
say that there is a long standing tradition which says that if you
make improvements to code that carries a certain license, you make
those improvements available under that same license.  The GPL makes
this part of the licensing conditions, whereas the BSD-like licenses
(such as the ISC license used in the origional ath5k driver) don't.
But that doesn't mean that the people in the "BSD camp" don't hold
that same viewpoint.  So I really hope that if you ever submit a patch
for the ath5k driver, you make it available under the conditions of
the ISC license as well as the GPL license.  The best way to do this,
is probably by explicitly stating this when you send a patch to the
linux-wirless or linux-kernel mailing list.

Thanks,

Mark Kettenis
