Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44008 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbZKRB7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 20:59:36 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NAZpe-0005hh-0N
	for linux-wireless@vger.kernel.org; Wed, 18 Nov 2009 02:59:42 +0100
Received: from 206-248-130-60.dsl.teksavvy.com ([206.248.130.60])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 02:59:41 +0100
Received: from monnier by 206-248-130-60.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 02:59:41 +0100
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: [RFC v2] mac80211: disallow bridging managed/adhoc interfaces
Date: Tue, 17 Nov 2009 20:59:03 -0500
Message-ID: <jwvy6m4bnqp.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
References: <1258465585.3682.7.camel@johannes.local>
	<1258490898.21197.42.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> A number of people have tried to add a wireless interface
> (in managed mode) to a bridge and then complained that it
> doesn't work. It cannot work, however, because in 802.11
[...]
> To avoid such mistakes in the future, disallow adding a
> wireless interface to a bridge.

As someone who's been bitten by this, I fully support this change.
Still, it makes me wonder: my broadcom-based home-router using the wl.o
driver can be set in "client bridge" mode.  How does it work?


        Stefan

