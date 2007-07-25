Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21861 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbXGYOnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 10:43:13 -0400
Received: from lin01.mn-solutions.de (pD95F885D.dip0.t-ipconnect.de [217.95.136.93])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 19CA68B215D
	for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 16:43:12 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id B54351E002B
	for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 16:43:06 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Please pull patch-bomb for iwlwifi
Date: Wed, 25 Jul 2007 16:43:14 +0200
References: <20070725085754.GA670@mail.intel.com> <46A75CD9.9050100@garzik.org>
In-Reply-To: <46A75CD9.9050100@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707251643.14926.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 1) You should post patches to the list for review.  Yes, even
> if there are 117 of them.  That is acceptable -- and
> encouraged -- mailing list etiquette.

Here I'm wondering if this is needed. For example, for the 
libertas WLAN driver we have an extra mailing list where people 
(mostly) post patches for review. Eventually, Dan Williams put 
them into his tree and then asks Linville to pull from him. But 
the patches in his GIT tree won't be sent to linux-wireless for 
individual review.

Now, isn't doing the iwlwifi project the same?  There is a 
mailinglist for this project 
(https://lists.sourceforge.net/lists/listinfo/ipw3945-devel) 
where anybody is free to join.

A cursory glance (I'm not in this mailing list) at 
http://sourceforge.net/mailarchive/forum.php?forum_name=ipw3945-devel 
shows that people indeed post patches there for review.

So, if you ask them to post each and every patch on 
linux-wireless, then other projects should do the same. Some 
projects (e.g. bcm43xx) mostly do cross-post. Is this the way 
people should go?
