Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2GJLJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 07:09:23 -0400
Message-ID: <1341918560.4475.10.camel@jlt3.sipsolutions.net> (sfid-20120710_130929_709666_D96AC731)
Subject: Re: kernel oops on wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 10 Jul 2012 13:09:20 +0200
In-Reply-To: <4FFC0BA2.3060107@broadcom.com> (sfid-20120710_130212_744547_93D9E56B)
References: <4FFC0BA2.3060107@broadcom.com>
	 (sfid-20120710_130212_744547_93D9E56B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-10 at 13:01 +0200, Arend van Spriel wrote:
> Recently I get a kernel oops in nightly test on the wireless-testing
> tree (see below). This is on 3.5-rc4 kernel based on following commit:
> 
> commit a5b846deb890fbea72267e4e7d98f8f022959d14
> Merge: 1532e30 bf52592
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Wed Jun 27 16:15:29 2012 -0400
> 
>     Merge branch 'master' of
> git://git.kernel.org/pub/scm/linux/kernel/git/linvi
> 
> Can this be expected (eg. recent change in struct wiphy) ? I will built
> a new kernel from wireless-testing and see if that helps.

Why would you expect this? Are you running new modules on an old kernel?

johannes

