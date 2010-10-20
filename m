Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:22281 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0JTSQm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 14:16:42 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o9KIGfRX008126
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 21:16:41 +0300
Subject: Re: [PATCH] wl1271: exit ELP mode when setting enabled rates in tx
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287579962.17497.330.camel@tukatila-desktop>
References: <1287577300-9240-1-git-send-email-luciano.coelho@nokia.com>
	 <1287579962.17497.330.camel@tukatila-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 21:16:13 +0300
Message-ID: <1287598573.2204.0.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-20 at 15:06 +0200, Tuomas Katila wrote:
> On Wed, 2010-10-20 at 14:21 +0200, ext luciano.coelho@nokia.com wrote:
> > From: Luciano Coelho <luciano.coelho@nokia.com>
> > 
> > This bug was being triggered by a call to acx_rate_policies in tx_work
> > without calling ps_elp_wakeup first.  If we have full PSM enabled, this
> > happens rather often, immediately after association.
> > 
> > Reported-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> > ---
> 
> Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
> 
> I couldn't reproduce the error after tens of tries.

Thanks Tuomas! Applied.

-- 
Cheers,
Luca.

