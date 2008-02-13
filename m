Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60218 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765048AbYBMX4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 18:56:25 -0500
Date: Thu, 14 Feb 2008 00:56:21 +0100
From: Sebastian Siewior <ipw+2200@ml.breakpoint.cc>
To: Dan Williams <dcbw@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"zHU, yI" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net
Subject: Re: [RFT] ipw2200: fix ucode assertion for RX queue overrun
Message-ID: <20080213235621.GA10003@Chamillionaire.breakpoint.cc> (sfid-20080213_235632_908105_D764DF4F)
References: <1202740070.2806.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1202740070.2806.9.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dan Williams | 2008-02-11 09:27:50 [-0500]:

>Restock the RX queue when there are a lot of unused frames so that the
>RX ring buffer doesn't overrun, causing a ucode assertion.  Backport of
>patch "iwlwifi: fix ucode assertion for RX queue overrun".
>
>Signed-off-by: Dan Williams <dcbw@redhat.com>
Tested-by: Sebastian Siewior <sebastian@breakpoint.cc>

>Sebastian, can you test and ensure that this works for you?  Also, can
Yep, it does.

>you do some throughput testing to ensure that this patch doesn't cause a
>throughput regression?  Thanks!
00:49:41 (666.64 KB/s) - `/dev/null' saved [122563640/122563640]

this was a wget from the inet and it hits almost my cap. Currently I don't
have another local machine where I can test a "local" transfer.

Is this okey for you?

Sebastian
