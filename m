Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63161 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1BQEV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 23:21:57 -0500
Received: by qwa26 with SMTP id 26so2062216qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 20:21:57 -0800 (PST)
Message-ID: <4D5CA260.1070807@lwfinger.net>
Date: Wed, 16 Feb 2011 22:21:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/2] ssb: improve device disabling
References: <1297903851-5499-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1297903851-5499-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/16/2011 06:50 PM, Rafał Miłecki wrote:
> With that patches we follow specs and (as recently proved by MMIO dumps) wl.
>
> The more important patch is the first one. It detects problem (and warns) with
> SSB when it is in some broken state. We can for example hit such an issue when
> enabling DMA on 14e4:4329 (N-PHY, rev 1). The real fix is now known yet, but
> not we at least get warning. Switching to PIO on that card does not raise
> warning anymore (as expected).
>
> We all hate regressions and Michal says than enabling/disabling SSB device can
> be tricky. I have tested that patches with few b43 driven devices:
> 14e4:4318 (BCM4318)
> 14e4:4315 (BCM4312)
> 14e4:4329 (BCM4321)
> 14e4:4328 (BCM4321)
> 14e4:432b (BCM4322)

I tested 14e4:4311 (BCM4311) and found no problems.

Larry
