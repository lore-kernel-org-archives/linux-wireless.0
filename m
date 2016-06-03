Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43058 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbcFCPzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 11:55:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 03 Jun 2016 21:25:00 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: remove 10.1 firmware support
In-Reply-To: <5751A6D5.7080901@candelatech.com>
References: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
 <20160603153328.11947-2-rmanohar@qti.qualcomm.com>
 <5751A6D5.7080901@candelatech.com>
Message-ID: <743182bcbd1efbdb576bcc51b0215300@codeaurora.org> (sfid-20160603_175508_017724_5D033339)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-03 21:18, Ben Greear wrote:
> On 06/03/2016 08:33 AM, Rajkumar Manoharan wrote:
>> Earlier qca9888 device was brought up using 10.1 firmware and then
>> later all firmware fixes and new features are migrated to 10.2/10.2.x
>> firmware branch. As all of 10.1 funtionalities are supported in 10.2
>> based firmware, removing 10.1 firmware support for qca9888 device.
> 
> Oh please do not do this.  My 10.1 firmware works very nicely,
> and out-performs 10.2 in my testing.  Lots of people use my firmware
> when they need IBSS support or other features not found in
> official firmware, so it is not just me that will have
> problems if you remove this support.
> 
Aah.. I thought CT firmware is 10.2 based. Since most of firmware bug 
fixes and enhancements are integrated into 10.2 based firmware, we 
thought of get rid of 10.1 firmware to reduce code size. Moreover 
existing 10.1 official firmware has known issues. Is it possible to 
upgrade CT firmware to 10.2 WMI/HTT interfaces?

-Rajkumar
