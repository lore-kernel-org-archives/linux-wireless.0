Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42280 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3FDVAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 17:00:11 -0400
Date: Tue, 4 Jun 2013 16:56:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, arend@broadcom.com
Subject: Re: pull request: wireless 2013-06-03
Message-ID: <20130604205630.GA11199@tuxdriver.com> (sfid-20130604_230019_877955_0A130DD9)
References: <20130603184817.GD2727@tuxdriver.com>
 <20130604.131813.134898245916084893.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130604.131813.134898245916084893.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 04, 2013 at 01:18:13PM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 3 Jun 2013 14:48:17 -0400
> 
> > Please let me know if there are problems!
> 
> Sorry, the broadcom brcmfmac changes need to go.
> 
> Some of those commits are cleanups, and some of them have the worst
> commit log messages ever, the last one for example:
> 
> 0017-brcmsmac-fix-regression-observed-in-3.10-rc1.patch
> 
> has no explanation whatsoever of what the actual problem or regression
> is, what aspect of the logic in that function is causing the problem,
> and no explanation why making this function always return 'false' is a
> reasonable fix.
> 
> That entire series is of very low quality, and even if it was in good
> shape, at least half the changes are not appropriate at all this late
> in the -rc series.

OK, sorry Dave -- I knew better...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
