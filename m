Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab2BMVH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 16:07:29 -0500
Subject: Re: RTLWIFI_DEBUG bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1329165326.4939.16.camel@joe2Laptop>
References: <1329142387.3365.6.camel@jlt3.sipsolutions.net>
	 <1329165326.4939.16.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Feb 2012 22:07:26 +0100
Message-ID: <1329167246.3458.0.camel@jlt3.sipsolutions.net> (sfid-20120213_220733_630048_A875BAB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-13 at 12:35 -0800, Joe Perches wrote:
> On Mon, 2012-02-13 at 15:13 +0100, Johannes Berg wrote:
> > config RTLWIFI_DEBUG
> >         tristate "Additional debugging output"
> >         depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
> >         default y
> > 
> > should be
> > 
> > config RTLWIFI_DEBUG
> >         bool "..."
> > 
> > as otherwise
> > 
> > +#ifdef CONFIG_RTLWIFI_DEBUG
> > can never be true in a modular build.
> 
> If you know the correct solution,
> perhaps you should submit a patch.

If I knew your attitude was going to be a problem, I'd never said
anything. I have better things to do.

johannes

