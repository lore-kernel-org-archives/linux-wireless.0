Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52468 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab3CLP21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 11:28:27 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id r2CFSQLw002857
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 10:28:26 -0500
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r2CFSC5m009081
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 10:28:25 -0500
Received: from [172.24.79.11] (h79-11.vpn.ti.com [172.24.79.11])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id r2CFMpBg031067	for
 <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 10:22:52 -0500
Message-ID: <1363101708.5453.47.camel@cumari.coelho.fi> (sfid-20130312_162830_849890_526E7FD6)
Subject: Re: [PATCH 00/13] wlcore/wl18xx: some patches for 3.10
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Date: Tue, 12 Mar 2013 17:21:48 +0200
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-12 at 15:44 +0200, Luciano Coelho wrote:
> Hi,
> 
> These are some of the TI wireless drivers patches that are intended
> for 3.10.
> 
> A bunch of fixes and small improvements here and there.
> 
> Please review.

There were a couple of checkpatch >80 chars warnings in this series.
I'll fix them before applying.

--
Luca.

