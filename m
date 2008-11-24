Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16168 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYKXByz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 20:54:55 -0500
Subject: Re: iwlagn MAC in deep sleep
From: Zhu Yi <yi.zhu@intel.com>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081121193348.GA7373@drd1813.lan>
References: <20081121193348.GA7373@drd1813.lan>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 09:55:15 +0800
Message-Id: <1227491716.2548.213.camel@debian.sh.intel.com> (sfid-20081124_025508_301464_CAC2F59C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-11-22 at 03:33 +0800, Mike Kershaw wrote:
> iwlagn: MAC is in deep sleep!
> pciehp: Card present on Slot(3)
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: Unable to init nic

Can you please look for something called vPRO/AMT in your BIOS and try
to disable it?

Thanks,
-yi

