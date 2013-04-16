Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta1.parkeon.com ([91.121.43.66]:53544 "EHLO mta1.parkeon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab3DPITN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 04:19:13 -0400
Message-ID: <516D097F.7030905@parkeon.com> (sfid-20130416_101918_010201_388456BD)
Date: Tue, 16 Apr 2013 10:19:11 +0200
From: Martin Fuzzey <mfuzzey@parkeon.com>
Reply-To: mfuzzey@parkeon.com
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware problems with Lesswire Wibear  11n module using mwifiex
References: <5155BF92.2020704@parkeon.com> <477F20668A386D41ADCC57781B1F70430D9DCBF173@SC-VEXCH1.marvell.com> <516BF8D0.5070401@parkeon.com> <477F20668A386D41ADCC57781B1F70430D9DF761EC@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DF761EC@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On 16/04/13 01:41, Bing Zhao wrote:

> That's right. The host controller and/or its driver need to be 
> checked. Thanks, Bing 

Ok I've fixed my host controller driver and it works now.

Patch submitted: [http://article.gmane.org/gmane.linux.kernel.mmc/20121]

Thank you for pointing me in the right direction.

Regards,

Martin

