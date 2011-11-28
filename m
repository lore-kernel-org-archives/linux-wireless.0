Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab1K1JVK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 04:21:10 -0500
Date: Mon, 28 Nov 2011 10:23:09 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: fix lps_lock deadlock
Message-ID: <20111128092308.GB2372@redhat.com> (sfid-20111128_102115_126780_2A5F5524)
References: <1322219327-23148-1-git-send-email-sgruszka@redhat.com>
 <4ECFD1BF.4070503@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4ECFD1BF.4070503@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 25, 2011 at 11:34:55AM -0600, Larry Finger wrote:
> Thanks for fixing this problem. The patch also fixes the lockdep
> warning I was getting, but my knowledge of locking was not good
> enough to get the solution.
> 
> Is this problem related to
> https://bugzilla.redhat.com/show_bug.cgi?id=755154 and/or
> https://bugzilla.redhat.com/show_bug.cgi?id=754075? If so, perhaps
> they should be mentioned in the commit message.

I'll post v2 shortly with that information included.

> Is there a bug report by Oliver Paukstadt? I could not find one with Google.
It's here: 
https://bugzilla.redhat.com/show_bug.cgi?id=731365#c67
I did not reference that, becuse it's part of different bug report.
 
> Patch ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks
Stanislaw
