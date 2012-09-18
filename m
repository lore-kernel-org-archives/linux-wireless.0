Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2IRKhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 06:37:08 -0400
Message-ID: <1347964664.4283.0.camel@jlt4.sipsolutions.net> (sfid-20120918_123713_017321_8CB673AF)
Subject: Re: [PATCH] cfg80211: remove obselete comment for
 .sched_scan_stop() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Tue, 18 Sep 2012 12:37:44 +0200
In-Reply-To: <1347958799-4060-1-git-send-email-arend@broadcom.com>
References: <1347958799-4060-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-18 at 10:59 +0200, Arend van Spriel wrote:
> The kerneldoc comment for .sched_scan_stop() callback describes a
> driver_initiated flag, but the interface does not hold such a flag.
> 
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Johannes,
> 
> Was working on scheduled scan support for brcmfmac and got a little
> confused about .sched_scan_stop() documentation. Not sure if this
> was stale documentation.

Yes I believe this was some sort of circular call that we removed
(driver calls stop, cfg80211 tells driver it itself stopped??)

I'll apply this (and fix the typo ("obsolete") in the subject)

johannes

