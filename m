Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48711 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0LTOaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 09:30:15 -0500
Date: Mon, 20 Dec 2010 09:15:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Jonas H." <jonas@lophus.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Recent suspend/resume fix for which devices?
Message-ID: <20101220141531.GB10104@tuxdriver.com>
References: <4D0E19EB.3070802@lophus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D0E19EB.3070802@lophus.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 19, 2010 at 03:42:51PM +0100, Jonas H. wrote:
> Hello!
> 
> My AR9285 wireless card, used with the ath9k driver, stops working
> after supsend/resume - I have to reboot to make it work again.
> 
> Trying to figure out whether this is fixed for 2.6.37 I noticed
> commit f933ebed (in Linus' tree) "ath9k_htc: Fix suspend/resume. The
> HW has to be set to FULLSLEEP mode during suspend, ...".
> 
> My question is: Does that fix also apply to my card? I realize the
> patch only applies to ath9k_htc but I couldn't figure what "htc"
> stands for in this context.

Probably not.  Did you try reverting it?

> If it doesn't, does this mailing list also function as a bug tracker?

Sorta, but not really.  There is a bugzilla instance at bugzilla.kernel.org.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
