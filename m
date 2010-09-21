Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab0IUR2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 13:28:05 -0400
Subject: Re: Patch to get iw building on Fedora 8
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C98DFB6.10902@candelatech.com>
References: <4C98DFB6.10902@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 19:28:05 +0200
Message-ID: <1285090085.12764.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 09:39 -0700, Ben Greear wrote:
> I need this in order to get iw to build on Fedora 8.
> 
> [greearb@fs2 iw]$ git diff
> diff --git a/bitrate.c b/bitrate.c
> index 8de8839..9b6defc 100644
> --- a/bitrate.c
> +++ b/bitrate.c
> @@ -1,4 +1,6 @@
>   #include <errno.h>
> +#define  __USE_ISOC99
> +#include <stdlib.h>

had to add #ifndef guards, but applied it.

johannes

