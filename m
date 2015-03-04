Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34277 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932748AbbCDUbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 15:31:48 -0500
Message-ID: <1425501103.1810.15.camel@sipsolutions.net> (sfid-20150304_213152_646299_B3676A5C)
Subject: Re: [PATCH crda 2/4] allow people to turn off -Werror
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Mar 2015 21:31:43 +0100
In-Reply-To: <20150304202235.GB7320@vapier>
References: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
	 <1425498714-8654-2-git-send-email-vapier@gentoo.org>
	 <1425498807.1810.14.camel@sipsolutions.net> <20150304202235.GB7320@vapier>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-04 at 15:22 -0500, Mike Frysinger wrote:

> yes, if you wanted to support:
> 	WERROR= make
> 
> but the expectation is that you'd do:
> 	make WERROR=
> 
> in which case this code is working as i intended.

Oh, interesting, I wasn't even really aware of this difference :)

Heh. Goes to show why I shouldn't work with build systems ;-)

johannes

