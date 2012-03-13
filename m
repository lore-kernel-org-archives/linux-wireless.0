Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:37125 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760330Ab2CMW7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 18:59:07 -0400
Date: Tue, 13 Mar 2012 15:58:02 -0700 (PDT)
Message-Id: <20120313.155802.165343340749302246.davem@davemloft.net> (sfid-20120313_235933_239611_6C9BB17C)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-03-13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120313192119.GC5837@tuxdriver.com>
References: <20120313192119.GC5837@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 13 Mar 2012 15:21:20 -0400

> Stanislaw has given us two late-breaking fixes intended for 3.3.  One
> avoids a NULL pointer dereference in iwl3945, and the other corrects a
> locking issue in the rt2x00 driver that can lead to random traffic
> stalls.
> 
> Please let me know if there are problems!

Pulled, thanks.
