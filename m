Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39081 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbXFMT5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 15:57:13 -0400
Message-ID: <46704C14.8010907@garzik.org>
Date: Wed, 13 Jun 2007 15:57:08 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: Please pull 'libertas-upstream' branch of wireless-2.6
References: <20070529183347.GD3496@tuxdriver.com> <20070612210544.GF310@tuxdriver.com> <20070612210658.GG310@tuxdriver.com> <20070612210814.GH310@tuxdriver.com>
In-Reply-To: <20070612210814.GH310@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Patches identified by the libertas team as suitable for 2.6.23...
> 
> ---
> 
> The following changes since commit 82fde74b94f11eee1e9c30e43fb162f80a5e63c0:
>   Luis Carlos (1):
>         libertas: convert libertas_mpp into anycast_mask
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git libertas-upstream

since it sounds like some additional 2.6.22 (warning?) fixes will be 
coming, I'm going to hold off pulling this.  I would rather the wireless 
maintainer sort out the merging in this case :)  Once 2.6.22 is all 
upstream, please do resend this push...


