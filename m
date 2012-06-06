Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:59664 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757225Ab2FFRGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 13:06:37 -0400
Received: by lagu2 with SMTP id u2so5301233lag.40
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 10:06:34 -0700 (PDT)
Message-ID: <1339002393.7078.37.camel@cumari.coelho.fi> (sfid-20120606_190640_845065_C7ED46DE)
Subject: Re: [PATCH] wlcore: compare ssid_len before comparing ssids
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 20:06:33 +0300
In-Reply-To: <1337095918-8903-1-git-send-email-eliad@wizery.com>
References: <1337095918-8903-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 18:31 +0300, Eliad Peller wrote:
> When comparing 2 ssids the ssid_len must be taken
> into account. Otherwise, a substring will be treated
> as equal.
> 
> This bug might cause ssids to get scanned as
> public ssids (rather than hidden), resulting in
> broadcast probe request (instead of ssid-specific
> ones)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied and pushed to wl12xx.git/master.

--
Luca.

