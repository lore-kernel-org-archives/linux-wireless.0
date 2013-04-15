Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36492 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351Ab3DOXtN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 19:49:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "mfuzzey@parkeon.com" <mfuzzey@parkeon.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 15 Apr 2013 16:41:33 -0700
Subject: RE: Firmware problems with Lesswire Wibear  11n module using mwifiex
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DF761EC@SC-VEXCH1.marvell.com> (sfid-20130416_014917_069313_38D99428)
References: <5155BF92.2020704@parkeon.com>
 <477F20668A386D41ADCC57781B1F70430D9DCBF173@SC-VEXCH1.marvell.com>
 <516BF8D0.5070401@parkeon.com>
In-Reply-To: <516BF8D0.5070401@parkeon.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

> > Are you able to hook up an oscilloscope to check whether SDIO DAT1 pin stays low or not?
> Indeed,
> 
> DAT1 goes low after the command is sent and stays low until the card is
> reset.
> 
> No SDIO interrupts are received by the host controller (i.MX53)
> 
> So it looks like a host controller issue - right?

That's right. The host controller and/or its driver need to be checked.

Thanks,
Bing

> 
> Regards,
> 
> Martin

