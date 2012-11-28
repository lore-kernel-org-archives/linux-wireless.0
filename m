Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33760 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2K1Jza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:55:30 -0500
Message-ID: <1354096489.25524.18.camel@cumari.coelho.fi> (sfid-20121128_105535_065700_FA15B40F)
Subject: Re: [PATCH 00/11] wlcore fixes for 3.8 (part1)
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 28 Nov 2012 11:54:49 +0200
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 18:05 +0200, Arik Nemtsov wrote:
> Various fixes for wlcore, to be applied on top of
> Eliad's 18xx API update series.
> 
> There are more patches pending - the splitting into smaller
> series is meant to ease review.
> 
> Arik Nemtsov (2):
>   wlcore: use new set bandwidth command to adjusting channel BW
>   wlcore/wl18xx/wl12xx: separate channel count between chips
> 
> Eliad Peller (7):
>   wlcore: configure dwell times according to scan type
>   wlcore: don't stop fwlog if dbgpins are used
>   wlcore/wl18xx: allow TX BA on all TIDs
>   wlcore: use sta_state-based ROCs for AP mode
>   wlcore: mask out CCK rates when starting GO
>   wlcore: move ps change handling to .bss_info_changed()
>   wlcore: don't allow access to FW mem when chip is off
> 
> Luciano Coelho (1):
>   wlcore: gather information about firmware stability
> 
> Yair Shapira (1):
>   wlcore/wl18xx/wl12xx: add recovery settings to conf

Applied this set, except for 09/11.  Thanks!

--
Luca.

