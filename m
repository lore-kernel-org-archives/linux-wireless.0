Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:50970 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3FLHVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 03:21:04 -0400
Date: Wed, 12 Jun 2013 00:21:03 -0700 (PDT)
Message-Id: <20130612.002103.916991474696226731.davem@davemloft.net> (sfid-20130612_092139_108363_E85D17FC)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130611.222706.1492583255605214982.davem@davemloft.net>
References: <20130606190929.GB18827@tuxdriver.com>
	<20130611.222706.1492583255605214982.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


John, I also don't like the ATK9K Kconfig option name change added in
this pull request, this is exactly the kind of thing that drives
Linus insane.

Change the default, fine, but changing the name is unnecssary churn
and adds a new config prompt that people are going to respond to
incorrectly when they type "make oldconfig"

