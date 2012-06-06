Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:60125 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757026Ab2FFRGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 13:06:11 -0400
Received: by lahd3 with SMTP id d3so5587131lah.5
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 10:05:58 -0700 (PDT)
Message-ID: <1339002356.7078.35.camel@cumari.coelho.fi> (sfid-20120606_190613_941583_C2B46656)
Subject: Re: [PATCH] wl12xx/wl18xx: add erp protection IE to the beacon
 filter
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 20:05:56 +0300
In-Reply-To: <1337088920-29014-1-git-send-email-eliad@wizery.com>
References: <1337088920-29014-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 16:35 +0300, Eliad Peller wrote:
> We have to reconfigure the fw when erp protection should
> be enabled/disabled. Pass beacons containing changes
> in the ERP protection IE, so we could analyze them.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

--
Luca.

