Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45139 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250AbXGZHPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 03:15:35 -0400
Message-ID: <46A84A14.3080308@warmcat.com>
Date: Thu, 26 Jul 2007 08:15:32 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: provide frequency to radiotap monitor not channel  index
References: <11854204053593-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11854204053593-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> From: Andy Green <andy@warmcat.com>
> 
> iwlwifi wrongly provides the channel index to the radiotap header
> on Monitor mode. This results in tcpdump showing "6MHz" for example.
> 
> This patch arranges to send the frequency in MHz instead eg, 2437MHz
> 
> Signed-off-by: Andy Green <andy@warmcat.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Thanks.

-Andy
