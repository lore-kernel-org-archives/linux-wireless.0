Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32879 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbbKDHPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 02:15:14 -0500
Message-ID: <1446621310.2478.2.camel@sipsolutions.net> (sfid-20151104_081518_072348_775D22E0)
Subject: Re: [PATCH 2/2] iw: Removed the libnl-tiny >= 1 requirement
From: Johannes Berg <johannes@sipsolutions.net>
To: Dima Krasner <dima@dimakrasner.com>, linux-wireless@vger.kernel.org
Date: Wed, 04 Nov 2015 08:15:10 +0100
In-Reply-To: <150d1317b9d.cfdce22f1276537.435317345116585066@dimakrasner.com> (sfid-20151104_073201_819917_30C19821)
References: <150d1317b9d.cfdce22f1276537.435317345116585066@dimakrasner.com>
	 (sfid-20151104_073201_819917_30C19821)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-11-04 at 08:31 +0200, Dima Krasner wrote:
> Hi,
> 
> Recent libnl-tiny revisions do not specify a version in the pkg
> -config data. This patch corrects libnl-tiny support added in the 
> previous patch in the series, so it works with the latest revision 
> too.

You need to resend the patch (after reading iw's CONTRIBUTING file) -
so please just make a single one.

Thanks,
johannes
