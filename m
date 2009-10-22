Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:43218 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZJVHV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 03:21:57 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] libertas: move mic failure event to wext.c
Date: Thu, 22 Oct 2009 09:21:35 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <200910201505.14283.hs4233@mail.mn-solutions.de> <20091020085431.e26cce67.rdunlap@xenotime.net>
In-Reply-To: <20091020085431.e26cce67.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910220921.35223.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> argh.  urgh.  This file (or files) need to lose this
> non-kernel-doc function notation.  Please.

Two things here:

* it's a copy and paste patch, so we move things just to another 
place. This makes the cfg80211-patch less intrusive and also 
makes the driver way smaller, once we don't compile WEXT in or 
get rid of WEXT altogether. Normally for copy-and-paste patches 
you shouldn't change other things.

* When I started with libertas, those comments where mostly 
useful for me. I didn't care for /** or @, as I just read the 
text. For me, those extra decorations have a less 
negative "touch". The "positive" effect of having comments at 
all did by far outweight the formatting.


For new code, I use a "normal" comment style, for example see 
http://marc.info/?l=linux-wireless&m=125569942616188&w=2

So, if the comment style really annoys you, you could submit a 
comment-reformat-patch.

-- 
http://www.holgerschurig.de
