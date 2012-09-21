Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20683 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2IUSYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 14:24:10 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20572.45175.828538.204286@gargle.gargle.HOWL> (sfid-20120921_202415_534603_1338F363)
Date: Fri, 21 Sep 2012 23:52:47 +0530
To: Ben Greear <greearb@candelatech.com>
CC: Sujith Manoharan <c_manoha@qualcomm.com>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Add a debugfs file to adjust antenna diversity
In-Reply-To: <505CAEE4.7000906@candelatech.com>
References: <20572.4308.801973.961874@gargle.gargle.HOWL>
	<505C7984.1090600@candelatech.com>
	<20572.39015.872732.569065@gargle.gargle.HOWL>
	<505CAEE4.7000906@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Ok, that sounds interesting.
> 
> With the chainmask stuff, it turns out it was bad to set it through
> debugfs...  Can diversity be enabled/disabled through debugfs
> without worry?

I'll send a v2 with various checks to allow tweaking diversity
only when the chipset supports it etc. :)

Sujith
