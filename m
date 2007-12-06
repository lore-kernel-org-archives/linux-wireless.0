Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:51717 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbXLFWBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 17:01:23 -0500
Date: Thu, 6 Dec 2007 13:59:50 -0800
To: Shaddy Baddah <shaddy_baddah@hotmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071206215950.GA6987@bougret.hpl.hp.com> (sfid-20071206_220153_422358_9B2E1E16)
Reply-To: jt@hpl.hp.com
References: <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <20071121184459.GA17199@bougret.hpl.hp.com> <474F86AD.4040403@hotmail.com> <20071130202115.GA32444@bougret.hpl.hp.com> <20071204000138.GA1363@bougret.hpl.hp.com> <4756AABC.3000204@hotmail.com> <20071205215600.GA28349@bougret.hpl.hp.com> <4757336F.7050301@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4757336F.7050301@hotmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 06, 2007 at 10:25:35AM +1100, Shaddy Baddah wrote:
> Hi Jean,

	Hi again,

> >	So, you'll find attached a new version of Wireless Tools. Just
> >tell me if it work. You can remove the debugging output by commenting
> >out the "#define DEBUG" lines (grep for it).
> 
> Yes, that has fixed it. Thank you very much.

	Would you mind testing the attached version ? Following the
suggestions of David, I came up with a slightly better fix (use a
union instead of memcpy).
	As soon as I know it worka, I'll push that to the Debian
maintainer...

> Regards,
> Shaddy

	Thanks again for your help...

	Jean

