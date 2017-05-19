Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46265
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751330AbdESLL0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 07:11:26 -0400
Date: Fri, 19 May 2017 08:11:17 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/29] rfkill.txt: standardize document format
Message-ID: <20170519081117.6da0a699@vento.lan> (sfid-20170519_131204_940515_02BB9ECD)
In-Reply-To: <1495188901.3274.0.camel@sipsolutions.net>
References: <cover.1495157082.git.mchehab@s-opensource.com>
        <3361dce0e96427ed8fc375ab78371c0a6d0f55cc.1495157082.git.mchehab@s-opensource.com>
        <1495188901.3274.0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Fri, 19 May 2017 12:15:01 +0200
Johannes Berg <johannes@sipsolutions.net> escreveu:

> On Thu, 2017-05-18 at 22:25 -0300, Mauro Carvalho Chehab wrote:
> > 
> > +.. CONTENTS
> >  
> > +  1. Introduction
> > +  2. Implementation details
> > +  3. Kernel API
> > +  4. Userspace support  
> 
> Why not let this be auto-generated?
> 
> .. contents::
>    :depth: 1
> 
> should work, no?

Yes, it should work. Actually, you would need to use :depth: 2 to
produce this output:


	Contents

	    . rfkill - RF kill switch support
	        . Introduction
	        . Implementation details
	        . Kernel API
	        . Userspace support

I opted to keep the contents as a comment just because, in the past, some
maintainers complained about TOC removal, arguing that it makes harder
for the ones that would be reading the file in ascii.

Thanks,
Mauro
