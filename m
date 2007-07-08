Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:41187 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455AbXGHUcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 16:32:23 -0400
Message-ID: <469149D2.7090800@warmcat.com>
Date: Sun, 08 Jul 2007 21:32:18 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: ian <ischram@telenet.be>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi 3945: secondary interface disallows association
References: <4691310E.8070406@warmcat.com> <469142CC.1000903@telenet.be>
In-Reply-To: <469142CC.1000903@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ian wrote:

> I don't appear to have the same problem with:
>  -latest version of iwlwifi (0.0.35)
>  - gentoo-sources-2.6.20 kernel (patched with a relatively old mac80211
> package)
> 
> I believe fedora has 0.0.24 of iwlwifi embedded?

I don't know, this was yesterday's latest development kernel
2.6.22-0.5.rc7.git2.fc8 FWIW.

> So the problem might have been fixed already.

You're right Ian, I tested current wireless-dev git iwl3945 on another
laptop and it works correctly, I can even put the secondary interface
into Monitor mode and see stuff flying around and still ping things frmo
the default associated interface.  Great!

-Andy
