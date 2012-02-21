Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:50935 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2BUAYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 19:24:33 -0500
Date: Mon, 20 Feb 2012 19:23:24 -0500 (EST)
Message-Id: <20120220.192324.498901675497866305.davem@davemloft.net> (sfid-20120221_012513_806717_40AEAD04)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120220203740.GD6740@tuxdriver.com>
References: <20120220203740.GD6740@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 20 Feb 2012 15:37:40 -0500

> Here is another batch of fixes intended for 3.3.  Most of the fixes
> this time are for Bluetooth.

Pulled, but please read the bluetooth changes more carefully in the
future, there were a lot of coding style errors introduced this
time around.
