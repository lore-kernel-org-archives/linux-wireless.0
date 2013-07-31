Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab3GaO7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 10:59:24 -0400
Message-ID: <1375282753.8289.15.camel@jlt4.sipsolutions.net> (sfid-20130731_165931_667614_78AA99A5)
Subject: Re: 3.10, iwlwifi 6200AGN: AP changed bandwidth in a way we can't
 support - disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Date: Wed, 31 Jul 2013 16:59:13 +0200
In-Reply-To: <20130731145737.GC31017@hexapodia.org> (sfid-20130731_165746_082110_A8A42A60)
References: <20130729163452.GA454@hexapodia.org>
	 <20130731085956.GC1681@redhat.com> <20130731145737.GC31017@hexapodia.org>
	 (sfid-20130731_165746_082110_A8A42A60)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 07:57 -0700, Andy Isaacson wrote:
> On Wed, Jul 31, 2013 at 10:59:56AM +0200, Stanislaw Gruszka wrote:
> > We have few reports about this. Johannes, proposed this patch
> > http://p.sipsolutions.net/9d1dd0734d2c3a7a.txt
> > 
> > Could you check if it fixes the problem for you?
> 
> I unfortunately didn't get a chance to confirm before leaving Berlin,
> but the patch Johannes posted in the other thread seems to agree with my
> analysis of the problem, and Johannes confirmed from my pcap that it
> is the same problem.

I think we have two problems - the one you have should be fixed by the
patch I posted (not the one above) but the problem Chris is running into
has a WARN_ON() and isn't fixed.

johannes

