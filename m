Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:41875 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0LONMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 08:12:03 -0500
Subject: Re: [PATCH] wl1271: fixed problem with WPS IEs in probe requests
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291906499-21141-1-git-send-email-guy@wizery.com>
References: <1291906499-21141-1-git-send-email-guy@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 15:14:09 +0200
Message-ID: <1292418849.32385.3.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 16:54 +0200, ext Guy Eilam wrote:
> Inclusion of a WPS IE in probe requests caused a problem
> in the driver due to the maximum size of the probe request
> template and the max_scan_ie_len values at initialization.
> 
> Increased the size of probe request template
> to the maximum size allowed by the firmware.
> Struct wl12xx_probe_req_template, which was only used
> for calculating the max size of the probe request template,
> is no longer used and needed.
> 
> max_scan_ie_len is used for validating the size of
> additional IEs in scan requests.
> Initialized the max_scan_ie_len field to the maximum size
> of the probe request template minus the ieee80211 header size.
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---

Applied, thanks!


-- 
Cheers,
Luca.

