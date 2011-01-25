Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41161 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1AYTdS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 14:33:18 -0500
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0PJXH38022725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:33:17 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id p0PJXHxG001988
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:33:17 -0600 (CST)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0PJXHTD027709
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:33:17 -0600 (CST)
Received: from [172.24.68.5] (h68-5.vpn.ti.com [172.24.68.5])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0PJXEOv028883	for
 <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:33:15 -0600
Subject: Re: wl12xx tree rebased
From: Luciano Coelho <coelho@ti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295907199.4430.15.camel@pimenta>
References: <1295907199.4430.15.camel@pimenta>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 21:33:25 +0200
Message-ID: <1295984005.30502.146.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-24 at 23:13 +0100, Coelho, Luciano wrote:
> Hi,
> 
> I have rebased the wl12xx master and wl12xx-next branches with latest
> wireless-testing and wireless-next, respectively, as a base.
> 
> Please update your local trees.

We have experienced a few problems with 2.6.38-rc1 at least on the Zoom
boards (failing to boot), so I have created a tag with the old tree,
which is still based on 2.6.37.  The tag is wl12xx-2010-01-10.  It
doesn't contain all the latest patches for wl12xx, but at least it's
something that is proven to work.

If the problem is not solved soon, I'll add the latest patches on top of
the old tree too, so we can continue developing and testing with Zoom
boards.

-- 
Cheers,
Luca.

