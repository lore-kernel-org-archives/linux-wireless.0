Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39295 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab3JCUaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 16:30:15 -0400
Date: Thu, 3 Oct 2013 16:16:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Subject: Re: pull request: TI wireless drivers 2013-09-30 (for 3.13)
Message-ID: <20131003201604.GD3142@tuxdriver.com> (sfid-20131003_223023_928431_8F42293B)
References: <1380567110.4185.4.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380567110.4185.4.camel@porter.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 30, 2013 at 09:51:50PM +0300, Luca Coelho wrote:
> Hi John,
> 
> Here are some patches intended for 3.13.  Eliad is upstreaming a bunch
> of patches that have been pending in the internal tree.  Mostly bugfixes
> and other small improvements.
> 
> Please let me know if you have any problems with it!
> 
> The following changes since commit 772eb433357704ec3d6e0daa727d9ec3e85f50c1:
> 
>   rt2x00: Fix rf register for RT3070 (2013-09-26 15:17:30 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville
> 
> for you to fetch changes up to f2cede49ae7b9f51a6fe97ada16c27e4d03d05a3:
> 
>   wlcore: always register dummy hardirq (2013-09-30 21:12:22 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
