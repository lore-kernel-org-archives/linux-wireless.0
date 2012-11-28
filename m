Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42493 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab2K1JMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:12:12 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id qAS9CCA4005529
	for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 03:12:12 -0600
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qAS9CB77017400
	for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 03:12:12 -0600
Received: from [172.24.78.8] (h78-8.vpn.ti.com [172.24.78.8])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id qAS9CAce011036	for
 <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 03:12:10 -0600
Message-ID: <1354093891.25524.12.camel@cumari.coelho.fi> (sfid-20121128_101216_078590_15C3D6C6)
Subject: Re: [PATCH 0/2] wlcore: a couple of small clean-ups
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Date: Wed, 28 Nov 2012 11:11:31 +0200
In-Reply-To: <1353402212-20439-1-git-send-email-coelho@ti.com>
References: <1353402212-20439-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 11:03 +0200, Luciano Coelho wrote:
> Hi,
> 
> Just a couple of patches cleaning up things I bumped into.
> 
> Luca.
> 
> Luciano Coelho (2):
>   wlcore: avoid using goto in normal code flow
>   wlcore: remove a bunch of unnecessary parentheses
> 
>  drivers/net/wireless/ti/wlcore/main.c |   37 +++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 18 deletions(-)

Applied.

--
Luca.


