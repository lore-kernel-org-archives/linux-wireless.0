Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZC0HP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 03:15:27 -0400
Message-ID: <148ad3659dd1afe81ce6408e2a48715a.squirrel@secure.sipsolutions.net>
In-Reply-To: <1238113267.29544.14.camel@blob> 
References: <1238113267.29544.14.camel@blob>
Date: Fri, 27 Mar 2009 08:15:20 +0100 (CET)
Subject: Re: wireless-regdb: Update regulatory rules for Germany (DE) on
     5GHz
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Bernhard Seibold" <bernhard.seibold@uni-ulm.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bernhard Seibold wrote:

> The current regdb is missing a frequency range for Germany. That
> freq-range is military-controlled, so to be on the safe side, I asked
> the responsible agency, and they confirmed to me that it's legal to use.
> They also sent me the attached pdf (German only) which contains some
> details.


Odd, that document is from 2006, you'd think they would integrate it into
the 2008 release of the entire freq plan...

Can we find a URL for this one?

johannes

> Please CC me on replies.
>
>
> --- a/db.txt	2009-03-25 19:38:22.838975857 +0100
> +++ b/db.txt	2009-03-25 19:39:37.722248019 +0100
> @@ -165,8 +165,8 @@
>  country DE:
>  	# entries 279004 and 280006
>  	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> -	# entries 303005 and 304002
> -	(5150 - 5255 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
> +	# entries 303005, 304002 and 305002
> +	(5150 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
>  	# entries 308002 and 309001
>  	(5470 - 5650 @ 40), (N/A, 1000 mW), DFS
>
>
>

