Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab1DMTti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 15:49:38 -0400
Subject: Re: Google Summer of Code 2011 - Wireless application
From: Johannes Berg <johannes@sipsolutions.net>
To: Till Kamppeter <till.kamppeter@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4DA5FAF9.3090309@gmail.com>
References: <4DA5FAF9.3090309@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 21:49:35 +0200
Message-ID: <1302724175.3731.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-13 at 21:35 +0200, Till Kamppeter wrote:

> If you are not interested at all, please tell me ASAP so that I can 
> simply reject the applications on your behalf.

I won't have time to mentor anyone this year.


I do note, however, that the projects aren't really very well thought
out.

The IBSS one is concerned with TPT but somebody else is working on 11n
support anyway, for instance. Also multiple IBSS per HW, which is really
tricky and can only work in corner cases. Overall, I'm not convinced
this is a suitable project.

The second one is just totally useless.

The last one looks a bit like some googling around the problem space of
a basic idea ("improve roaming"), but offers no reasonable indication as
to actually achieving any type of solution, and any actual roaming
improvements wouldn't be in the kernel anyway.

Even if I had time to mentor, I think I'd reject these applications
anyway.

johannes

