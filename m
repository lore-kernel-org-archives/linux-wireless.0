Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:56377 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755559AbYDCVB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 17:01:58 -0400
Message-ID: <47F545C1.2010706@lwfinger.net> (sfid-20080403_220202_996894_95D9C521)
Date: Thu, 03 Apr 2008 16:01:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@gmail.com
Subject: Re: [PATCH] cfg80211: default to regulatory max power for channel
References: <47F5242D.80404@lwfinger.net> <1207251174-23860-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1207251174-23860-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> If the driver does not specify a maximum power output, default to the
> regulatory max.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Is this a worth alternative to Larry's b43legacy patch?  It looked like
> ath5k wasn't setting max_power either -- how does it work?

It works the same as my patch did. Yours is clearly better as it 
"fixes" all drivers.

Larry
