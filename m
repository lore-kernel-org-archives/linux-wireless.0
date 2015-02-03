Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47270 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbbBCIq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 03:46:56 -0500
Message-ID: <1422953213.2237.0.camel@sipsolutions.net> (sfid-20150203_094659_374433_2FEDB198)
Subject: Re: broken URLs of iwlwifi firmware tarballs
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Vladim=C3=ADr_=C4=8Cun=C3=A1t?= <vcunat@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Nix Dev <nix-dev@lists.science.uu.nl>
Date: Tue, 03 Feb 2015 09:46:53 +0100
In-Reply-To: <54CFF0B3.1060507@gmail.com> (sfid-20150202_224841_571486_202E34E5)
References: <54CFF0B3.1060507@gmail.com>
	 (sfid-20150202_224841_571486_202E34E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-02 at 22:48 +0100, Vladimír Čunát wrote:
> Hello,
> the URLs to iwlwifi firmware tarballs are broken. 
> https://wireless.wiki.kernel.org/en/users/Drivers/iwlwifi
> 
> Is that a temporary problem? I could find no mirrors for some of the 
> files. (Besides, I found that nixos.org isn't the only user of those URLs.)

This was a problem with the markup conversion for the new wiki engine -
the links were converted to [[filename]] (to link to pages) instead of
{{filename}} (to link to attachments)

I've fixed that now.

johannes

