Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:55260 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759976AbXIRRmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 13:42:49 -0400
Date: Tue, 18 Sep 2007 10:42:02 -0700
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit 4cf92a3c
Message-ID: <20070918174202.GB1466@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070917.042418.19962472.yoshfuji@linux-ipv6.org> <20070917165435.GA26926@bougret.hpl.hp.com> <46EF5534.3030609@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46EF5534.3030609@lwfinger.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 17, 2007 at 11:33:56PM -0500, Larry Finger wrote:
> John,
> 
> Yoshifuji Hideaki reported that commit 4cf92a3c broke the bcm43xx driver. I was able to duplicate
> the problem with WEP encryption and ifconfig control of the device. The problem does not happen with
> WPA or when using NetworkManager with WEP.
> 
> This patch was supposed to be a fix for the bug reported at
> http://bugzilla.kernel.org/show_bug.cgi?id=8686; however, it does not.
> 
> This commit should be reverted before 2.6.23 is released.
> 
> Thanks,
> 
> Larry

	Larry,

	Could you be more explicit ? Reverting the patch will just
bring back the old bug, and the old code was obviously wrong. I don't
like the idea of trading one bug for another bug. It looks to me like
nobody knows what's exactly happening in the driver and we are just
trying random fixes and see what breaks.
	Could you figure out what's exactly happening and make a
proper fix ?
	Regards,

	Jean
