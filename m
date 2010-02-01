Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50823 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab0BAQPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 11:15:35 -0500
Date: Mon, 1 Feb 2010 11:04:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bernhard Reiter <ockham@raz.or.at>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k/PCI 168C:002C
Message-ID: <20100201160430.GA4952@tuxdriver.com>
References: <1265039522.3610.55.camel@razor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1265039522.3610.55.camel@razor>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 01, 2010 at 04:52:02PM +0100, Bernhard Reiter wrote:
> hi,
> 
> i'm currently setting up karmic (64bit) an asus eeepc 1005p, and i've
> found the following in the debian wiki:
> http://wiki.debian.org/DebianEeePC/Model/1005P
> i'm giving this laptop to another person on wednesday, but until then, i
> might try to compile the ath9k module with the suggested addition of
> that PCI id.
> 
> unfortunately, i haven't really found anything on how to do this (in a
> least-invasive fashion). i've looked
> into /usr/src/linux-headers-2.6.31-17/drivers/net/wireless/ath/ath9k,
> but there's only a Kconfig and a Makefile, but no sources.
> 
> can you people help me modify, compile and test this module?
> 
> bernhard reiter
> ps please cc, i'm not a list subscriber

Seems more like a "how do I recompile my kernel on Ubuntu" question to me...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
