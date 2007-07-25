Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:39031 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759882AbXGYPMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 11:12:35 -0400
Message-ID: <46A7685D.7050703@warmcat.com>
Date: Wed, 25 Jul 2007 16:12:29 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please pull patch-bomb for iwlwifi
References: <20070725085754.GA670@mail.intel.com> <46A75CD9.9050100@garzik.org> <200707251643.14926.hs4233@mail.mn-solutions.de>
In-Reply-To: <200707251643.14926.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> A cursory glance (I'm not in this mailing list) at 
> http://sourceforge.net/mailarchive/forum.php?forum_name=ipw3945-devel 
> shows that people indeed post patches there for review.
> 
> So, if you ask them to post each and every patch on 
> linux-wireless, then other projects should do the same. Some 
> projects (e.g. bcm43xx) mostly do cross-post. Is this the way 
> people should go?

Because there are different gatekeepers between the upstream project and
the kernel maybe it should get reposted.  What the ipw3945-ites accept
can be different from what the mac80211-its can accept and even the
lkml-ites can kick stuff at the end of the game according to their
differing requirements.

IMO as importantly patches need a visible lifecycle when they are
posted.  If a patch arrives on a list, either:

 - someone should comment or advise triggering debate and/or a retry,
which deprecates the earlier try;

 - the patch should be replied to with a NAK because it is unacceptable,
perhaps because it inherently violates something or perhaps because the
retry identified as needed from the debate never came;

 - the patch should be replied to with a NAK because after debate it is
agreed the intention of the patch can be done better by someone more
experienced with the code;

 - or the patch should be ACK'd, with some sign of where it is committed
now.

-Andy
