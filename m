Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab3BTKE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:04:26 -0500
Message-ID: <1361354662.8629.12.camel@jlt4.sipsolutions.net> (sfid-20130220_110436_443828_C725A954)
Subject: Re: [PATCH v3] iw: add packet offset information for wowlan pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 20 Feb 2013 11:04:22 +0100
In-Reply-To: <1361321084-11325-1-git-send-email-bzhao@marvell.com>
References: <1361321084-11325-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-19 at 16:44 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Now user can provide packet offset along with the pattern in
> "iw wowlan" command. Default offset will be 0 when it is not
> provided.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
> v3: check struct size to avoid crash on old kernels; and use
>     '+' delimiter between offset and pattern. (Johannes Berg)
> v2: display maximum permissible packet offset as well for
>     WOWLAN patterns

Applied, thanks!

johannes

