Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42349 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2LSHzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 02:55:46 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v11] wireless: Driver for 60GHz card wil6210
Date: Wed, 19 Dec 2012 09:55:41 +0200
Message-ID: <33900997.BWB6JK0ljS@lx-vladimir> (sfid-20121219_085550_290021_44DE22DB)
In-Reply-To: <21521831.ovaVWPCQVP@lx-vladimir>
References: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <20121213205116.GQ15974@pogo> <21521831.ovaVWPCQVP@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, December 16, 2012 02:29:05 PM Vladimir Kondratiev wrote:
> Please find below patch where supported is "true" AP mode;
> PCP support dropped.
> Changes are mostly in the firmware, but few lines changed
> in the driver as well.
> 
> Johannes: does this address your concerns?
> 
> John: can this driver get to 3.8? Is it correct,
> "driver for new hardware" is eligible even if merge window already opened?
> 

Hi Johannes,

Any feedback? Now, when I removed all PBSS and support "true" AP mode,
iftype usage should be OK. I will work on PBSS later.

Thanks, Vladimir
