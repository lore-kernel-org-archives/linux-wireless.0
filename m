Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:61736 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaABV4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 16:56:52 -0500
Received: by mail-yh0-f51.google.com with SMTP id c41so2947100yho.38
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 13:56:51 -0800 (PST)
Date: Thu, 2 Jan 2014 13:56:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Question on compiler warning
In-Reply-To: <52C21CE3.3020402@lwfinger.net>
Message-ID: <alpine.DEB.2.02.1401021354400.21537@chino.kir.corp.google.com> (sfid-20140102_225733_258598_1449C089)
References: <52C21CE3.3020402@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Dec 2013, Larry Finger wrote:

> + /scratch/kisskb/src/drivers/net/wireless/b43/phy_n.c: warning: 'val_addr'
> may be used uninitialized in this function [-Wuninitialized]: => 178:21
> 
> This warning does not show up on any of my compilers, and it should not as the
> initialization and usage of that variable both take place in conditional
> branches that are testing exactly the same pointer.
> 

You may not be compiling this file depending on your .config or you may 
have a different setting for CONFIG_CC_OPTIMIZE_FOR_SIZE.
