Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54223
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbXIRWc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 18:32:58 -0400
Date: Tue, 18 Sep 2007 15:32:53 -0700 (PDT)
Message-Id: <20070918.153253.66805416.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, IvDoorn@gmail.com
Subject: Re: Please pull 'rt2x00' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070918213202.GJ4940@tuxdriver.com>
References: <20070918213202.GJ4940@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 18 Sep 2007 17:32:02 -0400

> This patch adds the rt2x00 drivers for Ralink wireless hardware.
> This collection of drivers has seen lots of action in Fedora (both
> F7 and rawhide) and many people are using them with good results
> (although some problems do remain).
> 
> Ivo in particular has been very helpful in responding to bug reports
> for these drivers, including bugs reported at kernel.org and in
> distro bugzillas.  I extend my thanks to him for both his past and
> future support of these drivers.  I'm sure he and the rest of the
> rt2x00 team will continue to support the community and their userbase.
> 
> Ivo and his team may feel I am jumping the gun a bit -- they have
> a few more random bugs they wanted to squash before going upstream.
> But since they are bugs, any fixes should still be able to be applied
> in the -rc phase of 2.6.24.  In the meantime, I definitely think it
> would be better to get this code into mainline rather than keeping
> it out of stream.

Applied to net-2.6.24 and pushed out.

Thanks John.
