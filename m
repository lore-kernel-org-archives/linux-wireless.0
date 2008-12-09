Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55309 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbYLITeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:34:14 -0500
Date: Tue, 9 Dec 2008 21:33:51 +0200
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Disable requests for new scans in AP mode
Message-ID: <20081209193351.GB16905@jm.kir.nu> (sfid-20081209_203417_826096_4F190EC0)
References: <20081209145722.GA2285@jm.kir.nu> <1228844410.17539.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228844410.17539.1.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 09, 2008 at 12:40:10PM -0500, Dan Williams wrote:

> Every 120 seconds usually (it uses a simple backoff algorithm), but
> yeah, this is a good thing to do.  You probably want to make NM ignore
> the device if you're configuring it as an AP though, since obviously NM
> shouldn't be driving an AP mode interface.

Actually, I would like to be able to NM to set up a simple AP similarly
to IBSS configuration.. If I'm setting up the interface manually (either
for AP or even for client modes), I would like NM to ignore the device
from that point on, but that is a separate point.

-- 
Jouni Malinen                                            PGP id EFC895FA
