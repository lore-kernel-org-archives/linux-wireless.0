Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54639 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbbJEGzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:55:00 -0400
Message-ID: <1444028098.1875.2.camel@sipsolutions.net> (sfid-20151005_085505_542841_F22C5631)
Subject: Re: iwlegacy and bridging iwl3945...? (sort of)
From: Johannes Berg <johannes@sipsolutions.net>
To: Morgan Read <mstuff@read.org.nz>, linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com
Date: Mon, 05 Oct 2015 08:54:58 +0200
In-Reply-To: <56118043.3080509@read.org.nz> (sfid-20151004_213850_404200_FF308D08)
References: <56118043.3080509@read.org.nz>
	 (sfid-20151004_213850_404200_FF308D08)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-10-04 at 20:38 +0100, Morgan Read wrote:
> 
> So, can I expect to be able to bridge my 802.11 connection to work 
> with my KVM guests?
> 

No, never over wireless, regardless of the driver.

(Unless you also control the software on the AP and can run openwrt or
such and use the Linux-specific 4-addr mode)

johannes
