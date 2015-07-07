Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42471 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852AbbGGNWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 09:22:30 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 02/13] wil6210: ACS implementation using QCA vendor command
Date: Tue, 7 Jul 2015 16:22:25 +0300
Message-ID: <65296673.xqVxgzcabI@lx-wigig-72> (sfid-20150707_152233_826481_BDA403B5)
In-Reply-To: <1436092516.6268.1.camel@sipsolutions.net>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1436081080-27305-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <1436092516.6268.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, July 05, 2015 12:35:16 PM Johannes Berg wrote:
> On Sun, 2015-07-05 at 10:24 +0300, Vladimir Kondratiev wrote:
> > ACS is implemented by registering to QCA vendor ACS sub command.
> > On receive of the command from hostapd, driver issues passive
> > scan command and block until scan results are available.
> > When received, the results are sent up using QCA vendor ACS
> > results event
> 
> I'm not convinced that we really want vendor commands upstream in the
> kernel. There at least we could go the extra mile to make proper non
> -vendor APIs, no?
> 
> johannes

We are looking into this and will be back soon.

Thanks, Vladimir
