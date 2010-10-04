Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0JDN2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 09:28:55 -0400
Subject: Re: [Patch] iw: Implement set 4addr.
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: Jochen Friedrich <jochen@scram.de>, linux-wireless@vger.kernel.org
In-Reply-To: <201010041502.14459.holgerschurig@gmail.com>
References: <1286041239-19169-1-git-send-email-jochen@scram.de>
	 <201010040915.58549.holgerschurig@gmail.com> <4CA997A3.7080409@scram.de>
	 <201010041502.14459.holgerschurig@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:28:51 +0200
Message-ID: <1286198931.3620.38.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 15:02 +0200, Holger Schurig wrote:
> > Yes, that's the idea behind this. I'm using an OpenWRT based WLAN router 
> > and a Debian client with the configuration below.
> 
> Oh, I don't have much success so far.
> 
> My setup is like this:
> 
>    Linux 2.6.35.4
>    compat-wireless-2010-10-02, using
>       ath5k from this
>    iw from git with your patch

What's your AP? You need to enable the 4addr mode on the AP as well.

johannes

