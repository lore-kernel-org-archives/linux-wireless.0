Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2FFIqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:46:50 -0400
Message-ID: <1338972409.4513.19.camel@jlt3.sipsolutions.net> (sfid-20120606_104654_736265_2984383E)
Subject: Re: [PATCH v3]: iw: fix the Makefile for multiple libnl
 installations
From: Johannes Berg <johannes@sipsolutions.net>
To: Guido Trentalancia <guido@trentalancia.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:46:49 +0200
In-Reply-To: <201206022346.q52NkkMX020927@vivaldi16.register.it>
References: <201206022346.q52NkkMX020927@vivaldi16.register.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Guido,


> Users with specific requirements can then pass specific CFLAGS and LIBS
> arguments to make, as in:
> 
> CFLAGS="-O2" make V=1 (libnl autodetection + optimisation + verbose)
> 
> NLLIBNAME=libnl-2.0 CFLAGS=-DCONFIG_LIBNL20 LIBS=-lnl-genl make (forced
> libnl version 2.0)

I decided that overriding the auto-detection isn't something I actually
want to support at this point since nobody has ever asked for it, so I
removed those parts of your patch and applied just the NLxxFOUND
corrections.

Thanks!

johannes

