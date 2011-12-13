Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40809 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab1LMJ2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 04:28:48 -0500
Received: by lagj5 with SMTP id j5so5385384lag.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 01:28:45 -0800 (PST)
Subject: Re: [PATCH] wl12xx: minor fix in sched_scan_ssid_list
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1323254224-8272-1-git-send-email-eyal@wizery.com>
References: <1323254224-8272-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 11:28:41 +0200
Message-ID: <1323768521.2800.84.camel@cumari> (sfid-20111213_102851_707509_25300B63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 12:37 +0200, Eyal Shapira wrote: 
> The user can pass broadcast SSID (ssid="") in the list of SSIDs for active scan.
> In this case the loop was attempting to match SSIDs in the filter
> list to this empty entry and marking them as HIDDEN (sending probe
> request) by mistake
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---

This has also been applied and pushed last week.

-- 
Cheers,
Luca.

