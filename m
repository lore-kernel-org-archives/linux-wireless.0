Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:20574 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0LONBy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 08:01:54 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBFD1rfc020522
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 15:01:54 +0200
Subject: Re: [PATCH 2/2] wl1271_sdio_test: Add module for sdio RX/TX testing
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: linux-wireless@vger.kernel.org, carlos.chinea@nokia.com
In-Reply-To: <1291197534-15319-1-git-send-email-roger.quadros@nokia.com>
References: <1291197534-15319-1-git-send-email-roger.quadros@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 15:03:39 +0200
Message-ID: <1292418219.32385.1.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 11:58 +0200, Roger Quadros wrote:
> From: Roger Quadros <roger.quadros@nokia.com>
> 
> This module enables individually generating RX and TX traffic
> over the SDIO bus on which the WL1271 chipset is connected.
> This is required to perform RF interference testing.
> 
> The module takes 2 module parameters 'rx' and 'tx'.
> 
> To generate RX traffic:
> 	modprobe wl1271_sdio_test rx=1
> To generate TX traffic:
> 	modprobe wl1271_sdio_test tx=1
> 
> To generate both RX & TX traffic, set both rx and tx to 1.
> 
> You can change the testing configuration at runtime by changing
> the rx & tx values at /sys/modules/wl1271_sdio_test/
> 
> To stop testing simply unload the module.
> 
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
> Reviewed-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---

Thanks Roger.  Applied.

-- 
Cheers,
Luca.

