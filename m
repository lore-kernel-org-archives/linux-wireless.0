Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:50832 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbbLSCZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 21:25:39 -0500
Date: Fri, 18 Dec 2015 21:25:37 -0500 (EST)
Message-Id: <20151218.212537.143932475051408734.davem@davemloft.net> (sfid-20151219_032549_037446_179BBBA4)
To: dvhart@infradead.org
Cc: jprvita@gmail.com, johannes@sipsolutions.net,
	corentin.chary@gmail.com, platform-driver-x86@vger.kernel.org,
	acpi4asus-user@lists.sourceforge.net, jprvita@endlessm.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] net/rfkill: Create "airplane mode" LED trigger
From: David Miller <davem@davemloft.net>
In-Reply-To: <20151219002212.GC7244@malice.jf.intel.com>
References: <1450193442-7930-1-git-send-email-jprvita@endlessm.com>
	<1450193442-7930-4-git-send-email-jprvita@endlessm.com>
	<20151219002212.GC7244@malice.jf.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Darren Hart <dvhart@infradead.org>
Date: Fri, 18 Dec 2015 16:22:12 -0800

> On Tue, Dec 15, 2015 at 10:30:41AM -0500, João Paulo Rechi Vita wrote:
>> For platform drivers to be able to correctly drive the "Airplane Mode"
>> indicative LED there needs to be a RFKill LED trigger tied to the global
>> state of RFKILL_TYPE_ALL (instead of to a specific RFKill) and that
>> works in an inverted manner of regular RFKill LED triggers, that is, the
>> LED is ON when the state is blocked, and OFF otherwise.
>> 
>> This commit implements such a trigger, which will be used by the
>> asus-wrc x86 platform driver.
> 
> So this will need to go through Johannes and David per get_maintainer.pl before
> we can use it in platform drivers.
> 
> +Johannes
> +David
> +wireless
> +netdev

RFKILL changes go via the wireless tree.
