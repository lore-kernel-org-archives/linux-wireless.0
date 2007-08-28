Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:57515 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXH1RPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 13:15:41 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IQ4f8-0004ZW-Db
	for linux-wireless@vger.kernel.org; Tue, 28 Aug 2007 13:15:34 -0400
Subject: Re: [PATCH] [360/2many] MAINTAINERS - ORINOCO DRIVER
From: Pavel Roskin <proski@gnu.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, orinoco-users@lists.sourceforge.net,
	orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	hermes@gibson.dropbear.id.au, akpm@linux-foundation.org
In-Reply-To: <46bffb31.f1XwyK4H0RsPvky8%joe@perches.com>
References: <46bffb31.f1XwyK4H0RsPvky8%joe@perches.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 13:15:22 -0400
Message-Id: <1188321322.2226.2.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-08-12 at 23:33 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 96aeb40..f374fa8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3463,6 +3463,7 @@ L:	orinoco-users@lists.sourceforge.net
>  L:	orinoco-devel@lists.sourceforge.net
>  W:	http://www.nongnu.org/orinoco/
>  S:	Maintained
> +F:	drivers/net/wireless/orinoco*

NAK.  Please also add airport*, spectrum* and hermes* in the same
directory.

Sorry for delay (due to vacation).

-- 
Regards,
Pavel Roskin

