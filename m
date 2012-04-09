Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56881 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2DISge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 14:36:34 -0400
Date: Mon, 9 Apr 2012 11:36:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: 3.2.8/amd64 full interrupt hangs and deadlocks under big network copies (page allocation failure)
Message-ID: <20120409183632.GO29342@merlins.org> (sfid-20120409_203643_501996_1CB58FE5)
References: <20120329163800.GH24933@merlins.org> <1333044575.2656.1.camel@bwh-desktop.uk.solarflarecom.com> <20120409172051.GR32290@merlins.org> <20120409.141241.1216091936509309354.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120409.141241.1216091936509309354.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 09, 2012 at 02:12:41PM -0400, David Miller wrote:
> From: Marc MERLIN <marc@merlins.org>
> Date: Mon, 9 Apr 2012 10:20:51 -0700
> 
> > Any idea what's going on, what bucket of RAM is an issue for the driver
> > (total RAM is more than plenty), and where I should go from there?
> 
> The wireless layer is allocating high-order pages, so it's
> not the amount of ram, it's the fragmentation of it leading
> to a lack of those high-order pages.

I figured it was something of the sort, thanks for the professional
confirmation :)

What's my next step, file a bug with a specific team?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
