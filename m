Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21807 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2KPLTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 06:19:37 -0500
Cc: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Message-ID: <50A62141.9080909@qca.qualcomm.com> (sfid-20121116_121940_310571_5F2E8DCA)
Date: Fri, 16 Nov 2012 13:19:29 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix a mismatch in power management debug message
References: <1350043841-2080-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1350043841-2080-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2012 03:10 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> Power Save Enabled : REC_POWER - conserve power
> without sacrificing performance.
> Power Save Disabled : MAX_PERF_POWER - maximum
> performance at the expense of power.
> Hence fix the debug message.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Thanks, applied.

Kalle
