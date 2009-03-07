Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:6098 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750865AbZCGCSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 21:18:54 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 2.6.29-rc6-wl] libertas: support mesh for variousfirmware versions
Date: Fri, 6 Mar 2009 18:18:53 -0800
Message-ID: <FE3F06125A99254E8D92161AA4569C6F0671DCD0@sc-exch02.marvell.com> (sfid-20090307_031937_240912_0B3DE3AB)
In-Reply-To: <20090306143832.GB3712@tuxdriver.com>
References: <FE3F06125A99254E8D92161AA4569C6F066BF4ED@sc-exch02.marvell.com> <20090306143832.GB3712@tuxdriver.com>
From: "Bing Zhao" <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <libertas-dev@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Lines were wrapped by my MTA in previous post, sorry.
I resent the patch.

Thanks,

Bing

-----Original Message-----
From: John W. Linville [mailto:linville@tuxdriver.com] 
Sent: Friday, March 06, 2009 6:39 AM
To: Bing Zhao
Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.29-rc6-wl] libertas: support mesh for
variousfirmware versions

On Thu, Mar 05, 2009 at 04:17:14PM -0800, Bing Zhao wrote:
> 
> CMD_MESH_CONFIG command ID and a couple of structure members in TxPD,
> RxPD have been changed in firmware version 10.x.y.z and newer.
> 
> Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/libertas/cmd.c     |   26 +++++++++++++++++-
>  drivers/net/wireless/libertas/defs.h    |   21 ++++++++++++++
>  drivers/net/wireless/libertas/dev.h     |    1 +
>  drivers/net/wireless/libertas/host.h    |    3 +-
>  drivers/net/wireless/libertas/hostcmd.h |   28 +++++++++++++++++---
>  drivers/net/wireless/libertas/main.c    |   44
> +++++++++++++++++++------------

This patch is whitespace-damaged...

John
-- 
John W. Linville		Someday the world will need a hero, and
you
linville@tuxdriver.com			might be all we have.  Be ready.
