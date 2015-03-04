Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34145 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246AbbCDTxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 14:53:33 -0500
Message-ID: <1425498807.1810.14.camel@sipsolutions.net> (sfid-20150304_205336_144077_04F9324E)
Subject: Re: [PATCH crda 2/4] allow people to turn off -Werror
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Mar 2015 20:53:27 +0100
In-Reply-To: <1425498714-8654-2-git-send-email-vapier@gentoo.org> (sfid-20150304_205207_348128_4A5AEDAB)
References: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
	 <1425498714-8654-2-git-send-email-vapier@gentoo.org>
	 (sfid-20150304_205207_348128_4A5AEDAB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-04 at 14:51 -0500, Mike Frysinger wrote:
> From: Mike Frysinger <vapier@chromium.org>
> 
> Forcing -Werror at build time easily breaks across compiler settings,
> compiler versions, architectures, C libraries, etc...  Add a knob so
> distro peeps can turn it off.

> +WERROR = -Werror

Doesn't that need ?= ?

johannes

