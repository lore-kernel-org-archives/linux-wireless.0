Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:40380 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbYFPJuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 05:50:05 -0400
From: Chr <chunkeey@web.de>
To: "Mark Roberts" <mroberts1839@gmail.com>
Subject: Re: Problem with master mode on BCM4318
Date: Mon, 16 Jun 2008 11:49:58 +0200
Cc: linux-wireless@vger.kernel.org
References: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com> <200806161026.28445.chunkeey@web.de> <eaf2efa20806160145s3501c07wb50f7d31efb755c0@mail.gmail.com>
In-Reply-To: <eaf2efa20806160145s3501c07wb50f7d31efb755c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806161149.59120.chunkeey@web.de> (sfid-20080616_115033_081288_53D82F8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 16 June 2008 10:45:41 Mark Roberts wrote:
> >> What steps should I take to apply the patches?
> >
> > well, I don't know much about compat-wireless, but
> > for the current wireless-dev, you have to get atleast one patch form:
> >
> > http://johannes.sipsolutions.com/patches/kernel/all/LATEST/
> >
> > and there: 006-allow-ap-vlan-modes.patch
>
> OK. I've never done this before. What should I do to apply the patch?
well?! install the "patch" utility with your distribuation's package system...
now you can run something like:
patch -d /path-to-wireless-dev/ -p1 <  /path-to/006-allow-ap-vlan-modes.patch

to apply the patch 006-allow-ap-vlan-modes.patch to the wireless-dev tree...
BTW, you should take a look at the documentation & manuals of "patch" too,
run "man patch" or ask google (e.g http://linux.die.net/man/1/patch, 
http://www.linuxhq.com/patch-howto.html )...

>
> > For the userspace: you have to compile the _cutting-edge_ hostapd (afaik
> > 0.6.4 git), you'll need it even for a unencrypted network!
>
> Looking here:
>
>   http://hostap.epitest.fi/hostapd/
>
> The latest I see is 0.6.3 -- will that do?
AFAIK not with the current wireless-dev... you have to get the "git-tree" 
( "git-clone git://w1.fi/srv/git/hostap.git" ) 

see http://hostap.epitest.fi/cvs.html and "man git / man git-clone" for 
further instructions and examples.
  
Regards,
	Chr
