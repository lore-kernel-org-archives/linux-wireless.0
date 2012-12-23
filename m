Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55390 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2LWJox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2012 04:44:53 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for US on 60gHz band
Date: Sun, 23 Dec 2012 11:36:03 +0200
Message-ID: <42386442.bUoSgr792i@lx-vladimir> (sfid-20121223_104534_134909_8D1135BA)
In-Reply-To: <8774585.BvFN3Opv12@lx-vladimir>
References: <8774585.BvFN3Opv12@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, December 09, 2012 04:16:21 PM Vladimir Kondratiev wrote:
> Subject: [PATCH] wireless-regdb: add regulatory rule for US on 60gHz band
> 
> There is coming 802.11ad standard that defines WiFi operations on the new band 60g.
> 
> In the US, reference document is:
> 
> http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 

Hi John,

Any comments? Can you please merge this patch?

Same about 2 more, with 60g for Europe and China. Titled as:

[PATCH] wireless-regdb: add regulatory rule for ETSI members on
 60gHz band
[PATCH] wireless-regdb: add regulatory rule for China on 60GHz band

Thanks, Vladimir.
