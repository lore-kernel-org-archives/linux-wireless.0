Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27106 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392AbaBLCjp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 21:39:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 11 Feb 2014 18:39:12 -0800
Subject: RE: [PATCH v2 08/30] mwifiex: implement extended scan feature
Message-ID: <477F20668A386D41ADCC57781B1F70430F5393DADC@SC-VEXCH1.marvell.com> (sfid-20140212_033949_094915_1269413C)
References: <1391819017-20995-1-git-send-email-bzhao@marvell.com>
 <1391819017-20995-4-git-send-email-bzhao@marvell.com>
 <20140211072128.GR5487@us.netrek.org>
In-Reply-To: <20140211072128.GR5487@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

Thanks for your comment.

> > + * This function prepares an extended scan command to be sent to the firmware
> > + *
> > + * This uses the scan command configiguration sent to the command processing
> 
>                                       ^
> 
> trivial typo, should be "configuration".

I will send a v3 for this patch.


Hi John,

If you prefer resending the entire patch series, please let me know.

Thanks,
Bing

