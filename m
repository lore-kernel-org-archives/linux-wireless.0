Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37512 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdESLRN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 07:17:13 -0400
Message-ID: <1495192604.3274.5.camel@sipsolutions.net> (sfid-20170519_131740_559606_419B7A6E)
Subject: Re: [PATCH 08/29] rfkill.txt: standardize document format
From: Johannes Berg <johannes@sipsolutions.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Date: Fri, 19 May 2017 13:16:44 +0200
In-Reply-To: <20170519081117.6da0a699@vento.lan>
References: <cover.1495157082.git.mchehab@s-opensource.com>
         <3361dce0e96427ed8fc375ab78371c0a6d0f55cc.1495157082.git.mchehab@s-opensource.com>
         <1495188901.3274.0.camel@sipsolutions.net>
         <20170519081117.6da0a699@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-05-19 at 08:11 -0300, Mauro Carvalho Chehab wrote:
> 
> Yes, it should work. Actually, you would need to use :depth: 2 to
> produce this output:
> 
> 
> 	Contents
> 
> 	    . rfkill - RF kill switch support
> 	        . Introduction
> 	        . Implementation details
> 	        . Kernel API
> 	        . Userspace support

Sounds good to me.

> I opted to keep the contents as a comment just because, in the past,
> some maintainers complained about TOC removal, arguing that it makes
> harder for the ones that would be reading the file in ascii.

Ok. I don't really care much either way, I guess. The file is short
enough that the TOC isn't all that important to start with.

johannes
