Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37511 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbbJOJsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 05:48:54 -0400
Message-ID: <1444902530.1969.0.camel@sipsolutions.net> (sfid-20151015_114857_348612_8175DD34)
Subject: Re: [RFC] cfg80211: support loading regulatory database as firmware
 file
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 15 Oct 2015 11:48:50 +0200
In-Reply-To: <1444902437-25742-1-git-send-email-johannes@sipsolutions.net> (sfid-20151015_114724_119413_F888E0E0)
References: <1444902437-25742-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20151015_114724_119413_F888E0E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +> 	> return request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
> +> 	> 	> 	> 	>        ®_pdev->dev, GFP_KERNEL,
> +> 	> 	> 	> 	>        (void *)alpha2, regdb_fw_cb);
> 
That should have some kind of signature validation though.

Luis, is that going anywhere?

johannes
