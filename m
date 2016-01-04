Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:45502 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbcADROQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 12:14:16 -0500
Date: Mon, 04 Jan 2016 12:14:10 -0500 (EST)
Message-Id: <20160104.121410.1963933976498579568.davem@davemloft.net> (sfid-20160104_181433_496400_790AF328)
To: dan.carpenter@oracle.com
Cc: elfring@users.sourceforge.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, kvalo@codeaurora.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	julia.lawall@lip6.fr
Subject: Re: [PATCH 1/3] rsi: Delete unnecessary variable initialisations
 in rsi_send_mgmt_pkt()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20160104092857.GD5284@mwanda>
References: <5687E169.4070704@users.sourceforge.net>
	<5687E203.1070404@users.sourceforge.net>
	<20160104092857.GD5284@mwanda>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 4 Jan 2016 12:28:57 +0300

> Please stop sending cleanup patches, Markus.  Just send fixes.

+1
