Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:55836 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757225Ab2FFRG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 13:06:28 -0400
Received: by lbon10 with SMTP id n10so9062632lbo.27
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 10:06:15 -0700 (PDT)
Message-ID: <1339002373.7078.36.camel@cumari.coelho.fi> (sfid-20120606_190632_183661_653ACB06)
Subject: Re: [PATCH] wlcore: set channels 12-14 as pactive for sched scan
From: Luciano Coelho <coelho@ti.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 06 Jun 2012 20:06:13 +0300
In-Reply-To: <1337090680-24733-1-git-send-email-victorg@ti.com>
References: <1337090680-24733-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 17:04 +0300, Victor Goldenshtein wrote:
> Introduce “pactive” scan mode – which instructs the fw to
> perform a passive scan until an activity/energy is detected
> on these channels, once energy detected the channel becomes
> active.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---

Applied, thanks Victor!

--
Luca.

