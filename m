Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout07.t-online.de ([194.25.134.83]:46630 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1BIQsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 11:48:25 -0500
Message-ID: <4D52C54A.2010709@t-online.de>
Date: Wed, 09 Feb 2011 17:48:10 +0100
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com
Subject: Re: [RFC] ath9k: Fix ath9k prevents CPU to enter C3 states
References: <1297262007-15128-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1297262007-15128-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>
> The DMA latency issue is observed only in Intel pinetrail platforms but
> in the driver we had a default PM-QOS value of 55. This caused
> unnecessary power consumption and battery drain in other platforms.
> Address this issue by disabling PM-QOS by default by setting it's value
> as '0' and making code changes appropriately.This addresses the bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=27532
> 	If the user sees some DMA latency issue he can still use the pmqos as a
> module parameter to trade power for throughput as below:
> sudo modprobe ath9k pmqos=55
>
> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
Acked-By: Richard Schütz <r.schtz@t-online.de>

Looks good to me with the exception of ATH9K_PM_QOS_DEFAULT_VALUE. But 
John already mentioned that.

-- 
Regards,
Richard Schütz
