Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbXIRVeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 17:34:10 -0400
Date: Tue, 18 Sep 2007 14:32:24 -0700 (PDT)
Message-Id: <20070918.143224.94038422.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, sam@ravnborg.org
Subject: Re: Please pull 'b43' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070918202819.GI4940@tuxdriver.com>
References: <20070918202819.GI4940@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 18 Sep 2007 16:28:19 -0400

> This series adds the b43 and b43legacy drivers, as well as the ssb
> bus infrastructure upon which they depend.
> 
> These drivers support the BCM43xx wireless hardware from Broadcom.
> The b43 driver supports modern hardware using the "version 4" firmware,
> while the b43legacy driver uses the "version 3" firmware to support
> some older devices which lack the resources to run the newer (and
> more feature rich) firmware.  Both drivers have performed well in
> -mm and Fedora rawhide, and b43 has performed well in later Fedora
> 7 kernels as well.
> 
> Furthermore, Michael and Larry have both demonstrated a strong
> commitment to the community and their users.  They both have responded
> to bugs both at the kernel.org bugzilla and in distro bugzillas.
> I have every confidence that they will continue to support their
> drivers at the same high standard that have already set.  I'd like
> to take this opportunity to thank both of them for their support both
> in the past and in the future as well.
> 
> No doubt there are still problems here.  But again, I think we would
> be better served by mainlining this code rather than continuing to
> maintain it out of stream.

John, I'm adding this and the iwlwifi bits to my net-2.6.24
tree.

Thanks.
