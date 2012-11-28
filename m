Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51713 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab2K1KSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 05:18:44 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id qASAIiuJ005336
	for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 04:18:44 -0600
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qASAIilV000646
	for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 04:18:44 -0600
Received: from [172.24.78.8] (h78-8.vpn.ti.com [172.24.78.8])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id qASAIg44030105	for
 <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 04:18:43 -0600
Message-ID: <1354097884.25524.27.camel@cumari.coelho.fi> (sfid-20121128_111847_934865_5678377A)
Subject: Re: [PATCH 0/6] wlcore/wl18xx/wl12xx: firmware version checks
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Date: Wed, 28 Nov 2012 12:18:04 +0200
In-Reply-To: <1354024321-20635-1-git-send-email-coelho@ti.com>
References: <1354024321-20635-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 15:51 +0200, Luciano Coelho wrote:
> Hi,
> 
> This a patchset to try to make as much sense as possible from the
> firmware version checks.  Unfortunately, wl12xx and wl18xx have
> different rules for each of the available fields, so we need to
> compromise and make it generic enough so that it works with both
> chips.
> 
> Cheers,
> Luca
> 
> Luciano Coelho (6):
>   wlcore/wl12xx: move wl12xx chip ID defines to the lower driver
>   wlcore/wl12xx: remove deprecated FW version check
>   wlcore: change way of checking the firmware version
>   wl12xx: ignore some of the firmware version fields
>   wlcore/wl12xx/wl18xx: verify multi-role and single-role fw versions
>   wl18xx: ignore irrelevant firmware version fields

Applied the series.

--
Luca.

