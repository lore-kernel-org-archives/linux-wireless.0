Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3476 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833AbYEHTax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 15:30:53 -0400
Date: Thu, 8 May 2008 14:53:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: xemul@openvz.org, johannes@sipsolutions.net, netdev@axxeo.de,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4][MAC80211]: Fix GFP_KERNEL allocation under read
	lock.
Message-ID: <20080508185323.GB7250@tuxdriver.com> (sfid-20080508_213016_918429_8115B4B7)
References: <4820997E.1070305@openvz.org> <20080506.134047.86330538.davem@davemloft.net> <4821442D.8010801@openvz.org> <20080506.225950.181623233.davem@davemloft.net> <20080508185123.GA7250@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080508185123.GA7250@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 08, 2008 at 02:51:23PM -0400, John W. Linville wrote:
> On Tue, May 06, 2008 at 10:59:50PM -0700, David Miller wrote:
> 
> > Whether you should resubmit your patch is up to the wireless
> > folks :-)
> 
> If you don't do it Ingo Oeser's way then it looks like you would need
> a patch like the one below.  And with the patch below, the last hunk
> of your patch will probably need to be fixed-up to match.

Ah, sorry -- I guess I should have read the whole series before
commenting... :-)

John
-- 
John W. Linville
linville@tuxdriver.com
