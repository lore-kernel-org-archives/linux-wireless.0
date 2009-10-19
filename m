Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:56755 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZJSHCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 03:02:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: libertas + cfg80211: road for kernel inclusion?
Date: Mon, 19 Oct 2009 09:02:29 +0200
Cc: linux-wireless@vger.kernel.org
References: <200910161426.22206.hs4233@mail.mn-solutions.de> <1255709780.14241.26.camel@localhost.localdomain>
In-Reply-To: <1255709780.14241.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910190902.29352.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> BTW, do you have any rough counts of the LoC you've removed from the
> driver as a result of this?  Ideally you could remove a cargo-ship's
> worth of work I did back in 2007 and you know what?  I like that :)

Oh, that's easy. The last diffstat for my cfg80211 patch was 

 22 files changed, 2107 insertions(+), 1855 deletions(-)


But the patch doesn't currently remove some files, so if I do

$ wc --lines wext.* 11d.* scan.* assoc.*
  2320 wext.c
    10 wext.h
   696 11d.c
   105 11d.h
  1212 scan.c
    33 scan.h
  1865 assoc.c
    16 assoc.h
  6257 tota

So, we have 1855 + 6257 = 8112 deletions.
