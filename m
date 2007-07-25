Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXGYUmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:42:15 -0400
Subject: Re: Please pull patch-bomb for iwlwifi
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200707251643.14926.hs4233@mail.mn-solutions.de>
References: <20070725085754.GA670@mail.intel.com>
	 <46A75CD9.9050100@garzik.org>
	 <200707251643.14926.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 16:40:22 -0400
Message-Id: <1185396022.15817.7.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-07-25 at 16:43 +0200, Holger Schurig wrote:
> > 1) You should post patches to the list for review.  Yes, even
> > if there are 117 of them.  That is acceptable -- and
> > encouraged -- mailing list etiquette.
> 
> Here I'm wondering if this is needed. For example, for the 
> libertas WLAN driver we have an extra mailing list where people 
> (mostly) post patches for review. Eventually, Dan Williams put 
> them into his tree and then asks Linville to pull from him. But 
> the patches in his GIT tree won't be sent to linux-wireless for 
> individual review.

Ideally, that should fall off dramatically over time.  I'd like to move
most patch traffic from libertas-dev to linux-wireless once the patch
volume slows down, as I now think it has.  So in the future, I wouldn't
mind posting most libertas patches to linux-wireless instead of
libertas-dev.

I'd also like to just get rid of the libertas-2.6 git tree and make
Linville do all the patch merging work in the future, but that should
come after we transition most of the patch review to linux-wireless, so
maybe in a few months time.  Post 2.6.23 there probably shouldn't be
much traffic on libertas-dev, I suspect.

Dan

> Now, isn't doing the iwlwifi project the same?  There is a 
> mailinglist for this project 
> (https://lists.sourceforge.net/lists/listinfo/ipw3945-devel) 
> where anybody is free to join.
> 
> A cursory glance (I'm not in this mailing list) at 
> http://sourceforge.net/mailarchive/forum.php?forum_name=ipw3945-devel 
> shows that people indeed post patches there for review.
> 
> So, if you ask them to post each and every patch on 
> linux-wireless, then other projects should do the same. Some 
> projects (e.g. bcm43xx) mostly do cross-post. Is this the way 
> people should go?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

