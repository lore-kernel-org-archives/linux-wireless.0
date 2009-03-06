Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52903 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZCFOp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 09:45:28 -0500
Date: Fri, 6 Mar 2009 09:38:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.29-rc6-wl] libertas: support mesh for various
	firmware versions
Message-ID: <20090306143832.GB3712@tuxdriver.com> (sfid-20090306_154531_750736_605F3874)
References: <FE3F06125A99254E8D92161AA4569C6F066BF4ED@sc-exch02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F066BF4ED@sc-exch02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
