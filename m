Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35613 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3A2TPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 14:15:24 -0500
Date: Tue, 29 Jan 2013 14:03:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull request: TI wireless drivers 2013-01-17 v2 (for 3.9)
Message-ID: <20130129190341.GA2159@tuxdriver.com> (sfid-20130129_201528_093547_E572430A)
References: <1358498334.6252.75.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358498334.6252.75.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 18, 2013 at 10:38:54AM +0200, Luciano Coelho wrote:
> Hi John,
> 
> This is v2 of the pull request I sent yesterday.  The only difference is
> that I fixed my merge and removed a stray __devexit from wl12xx/main.c.
> 
> 
> Lots of bugfixes and improvements in our TI wireless drivers,
> including support for multi-channel.  Intended for 3.9.
> 
> There is a lot of patches.  This is because I couldn't do integration
> for a while and then we missed the 3.8 window.
> 
> Please let me know if you have any problems with it!
> 
> 
> The following changes since commit 660b9caaad380758c756a7e60397e33dab44fe3f:
> 
>   bcma: use consistent case for 'hex' constants (2013-01-14 15:10:41 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville
> 
> for you to fetch changes up to 5b37649bbcfc14c1ecfb76c5b018dd686924b946:
> 
>   Merge branch 'wl12xx-next' into for-linville (2013-01-18 09:59:08 +0200)

Pulled...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
