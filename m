Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60001 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab1BKQ3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 11:29:16 -0500
Date: Fri, 11 Feb 2011 11:28:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: jpo234 <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WPA for Ethernet?
Message-ID: <20110211162845.GC2224@tuxdriver.com>
References: <loom.20110211T163104-102@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <loom.20110211T163104-102@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 11, 2011 at 03:39:03PM +0000, jpo234 wrote:
> Hello all,
> is it possible to use the mac80211 (software) encryption infrastructure to
> encrypt data over non 802.11 interfaces? If not, how hard would this be?
> 
> IPsec and other VPN solutions are "tunnel centric" instead of "interface
> centric". I'm looking for a way to say "All inbound and outbound traffic through
> this interface must be encrypted with the following key.", just like WPA-PSK.

I believe wpa_supplicant can do the 802.1x authentication to gain
access to a port on a supporting switch.  However, I am not aware
of any standard for "encrypted ethernet" that would build upon that.
You might consider implementing your own code on top of the TUN/TAP
driver for point-to-point encrypted links?

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
