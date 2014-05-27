Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaE0GwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 02:52:12 -0400
Message-ID: <1401173514.30496.11.camel@jlt4.sipsolutions.net> (sfid-20140527_085215_932924_DA4246EB)
Subject: Re: [PATCH v3.15-rcX] Fix IBSS join by initializing
 last_scan_completed
From: Johannes Berg <johannes@sipsolutions.net>
To: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 27 May 2014 08:51:54 +0200
In-Reply-To: <m361ksvirt.fsf@t19.piap.pl> (sfid-20140526_141920_406189_96CE4710)
References: <m361ksvirt.fsf@t19.piap.pl>
	 (sfid-20140526_141920_406189_96CE4710)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-26 at 14:14 +0200, Krzysztof Hałasa wrote:
> Without this fix, freshly rebooted Linux creates a new IBSS, instead
> of joining existing one. Only when jiffies counter overflows after
> 5 minutes the IBSS can be successfully joined.
> 
> Intel Wireless 7260 PCIe.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

Applied, thanks.

johannes

