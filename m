Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47071 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZIQUAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 16:00:33 -0400
Date: Thu, 17 Sep 2009 15:51:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: ASIC Felix <ic.felix@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: regression?  No connection with master-2009-09-16 was fine
	until master-2009-09-14
Message-ID: <20090917195141.GB2562@tuxdriver.com>
References: <1253208348.6601.17.camel@darkslate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1253208348.6601.17.camel@darkslate>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2009 at 10:25:48AM -0700, ASIC Felix wrote:
> Hi,
> 
> with master-2009-09-16 my laptop can no longer connect to the network.
> I can see all the APs, but can't connect.
> The issue is new, w-t kernel master-2009-09-14 was fine.
> 
> Sorry for pasting the whole /var/log/messages from boot to boot,
> but I see anything obvious by myself.

Perhaps you could bisect between master-2009-09-14 and
master-2009-09-16?  There are only a handful of patches.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
