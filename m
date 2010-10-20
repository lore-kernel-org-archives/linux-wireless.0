Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:62085 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0JTNLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 09:11:51 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o9KDBnoT016324
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 16:11:49 +0300
Subject: Re: [PATCH] wl1271: exit ELP mode when setting enabled rates in tx
From: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
To: "ext luciano.coelho@nokia.com" <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287577300-9240-1-git-send-email-luciano.coelho@nokia.com>
References: <1287577300-9240-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 16:06:02 +0300
Message-ID: <1287579962.17497.330.camel@tukatila-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-20 at 14:21 +0200, ext luciano.coelho@nokia.com wrote:
> From: Luciano Coelho <luciano.coelho@nokia.com>
> 
> This bug was being triggered by a call to acx_rate_policies in tx_work
> without calling ps_elp_wakeup first.  If we have full PSM enabled, this
> happens rather often, immediately after association.
> 
> Reported-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---

Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>

I couldn't reproduce the error after tens of tries.

-Tuomas


