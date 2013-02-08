Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57303 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946101Ab3BHJVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:21:39 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id r189Lcig020167
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:21:38 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r189Lcpm030749
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:21:38 -0600
Received: from [172.24.79.4] (h79-4.vpn.ti.com [172.24.79.4])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id r189Las6009677	for
 <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:21:37 -0600
Message-ID: <1360315240.12803.27.camel@cumari.coelho.fi> (sfid-20130208_102422_744410_6CC53972)
Subject: Re: [PATCH] wlcore: don't hide real error code when booting fails
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Date: Fri, 8 Feb 2013 11:20:40 +0200
In-Reply-To: <1359535995-18092-1-git-send-email-coelho@ti.com>
References: <1359535995-18092-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 10:53 +0200, Luciano Coelho wrote:
> There's no need to hide the actual error that was reported when
> booting fails.  For instance, on I/O error, we were returing
> -EINVALID, which doesn't make sense at all.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

--
Luca.

