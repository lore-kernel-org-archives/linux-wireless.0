Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48777
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbXISUUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 16:20:15 -0400
Date: Wed, 19 Sep 2007 13:20:15 -0700 (PDT)
Message-Id: <20070919.132015.112854231.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: Re: Please pull 'p54' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070919195527.GD5483@tuxdriver.com>
References: <20070919195527.GD5483@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 19 Sep 2007 15:55:27 -0400

> This patch adds the p54 driver for prism54 hardware using the "soft
> MAC" firmware.  It includes modules for both PCI and USB drivers.
> 
> This driver has been in Fedora (both F7 and rawhide) for some time
> and has generally performed well.  No doubt there are some problems
> with the code, but still I think it would be better to mainline the
> driver than to keep it out of stream.

Merged to net-2.6.24, thanks John.
