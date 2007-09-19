Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2972 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485AbXISVlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 17:41:46 -0400
Date: Wed, 19 Sep 2007 17:27:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, gregkh@suse.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-usb-users@lists.sourceforge.net, zambrano@broadcom.com,
	mb@bu3sch.de
Subject: Re: Please pull 'ssb-drivers' branch of wireless-2.6
Message-ID: <20070919212756.GA3136@tuxdriver.com>
References: <20070919204428.GE5483@tuxdriver.com> <20070919.142529.03110023.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070919.142529.03110023.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2007 at 02:25:29PM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Wed, 19 Sep 2007 16:44:28 -0400

> > The second patch adds a driver for a USB OHCI device which lives on
> > the SSB bus.  Again, this is found on a number of SoC devices used
> > especially in wireless routers and APs.

> I'll let Greg take in the OHCI thing.  I would suggest that he
> queue it up, and then once I get the net-2.6.24 tree into the
> merge window (which contains the SSB stack) he can push the
> OHCI change in afterwards.

ACK

-- 
John W. Linville
linville@tuxdriver.com
