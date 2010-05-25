Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44411 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab0EYUpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 16:45:12 -0400
Date: Tue, 25 May 2010 16:42:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-05-25
Message-ID: <20100525204235.GA27002@tuxdriver.com>
References: <20100525170401.GE31753@tuxdriver.com>
 <4BFC331A.9030606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4BFC331A.9030606@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 25, 2010 at 10:29:14PM +0200, Gertjan van Wingerde wrote:
> On 05/25/10 19:04, John W. Linville wrote:

> > Gertjan van Wingerde (2):
> >       rt2x00: Fix rt2800usb TX descriptor writing.
> 
> The patch causing the breakage this patch fixes wasn't actually upstream yet. So, 
> applying this patch only is now introducing a bug in 2.6.35. I guess it is better
> to revert this patch for 2.6.35.

Hmmm...OK.  Which patch introduces the bug this was intended to fix?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
