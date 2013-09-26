Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9137 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436Ab3IZV52 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 17:57:28 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Thu, 26 Sep 2013 14:57:21 -0700
Subject: RE: [patch] mwifiex: potential integer underflow in
 mwifiex_ret_wmm_get_status()
Message-ID: <477F20668A386D41ADCC57781B1F70430F4507819C@SC-VEXCH1.marvell.com> (sfid-20130926_235733_116736_3301BB83)
References: <20130925085729.GC6661@elgon.mountain>
 <477F20668A386D41ADCC57781B1F70430F45077CDA@SC-VEXCH1.marvell.com>
 <20130925182359.GV6247@mwanda>
 <477F20668A386D41ADCC57781B1F70430F45077E52@SC-VEXCH1.marvell.com>
 <477F20668A386D41ADCC57781B1F70430F45078155@SC-VEXCH1.marvell.com>
 <20130926210703.GE6247@mwanda>
In-Reply-To: <20130926210703.GE6247@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> There are several other similar functions as well.  For example, the
> while loops in mwifiex_ret_tx_rate_cfg() and mwifiex_get_power_level().

Thanks for pointing it out. We will have them fixed.

Regards,
Bing

