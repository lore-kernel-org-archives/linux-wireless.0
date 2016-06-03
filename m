Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34130 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbcFCPsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 11:48:39 -0400
Subject: Re: [PATCH 2/2] ath10k: remove 10.1 firmware support
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
References: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
 <20160603153328.11947-2-rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5751A6D5.7080901@candelatech.com> (sfid-20160603_174843_265261_10212B5B)
Date: Fri, 3 Jun 2016 08:48:37 -0700
MIME-Version: 1.0
In-Reply-To: <20160603153328.11947-2-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2016 08:33 AM, Rajkumar Manoharan wrote:
> Earlier qca9888 device was brought up using 10.1 firmware and then
> later all firmware fixes and new features are migrated to 10.2/10.2.x
> firmware branch. As all of 10.1 funtionalities are supported in 10.2
> based firmware, removing 10.1 firmware support for qca9888 device.

Oh please do not do this.  My 10.1 firmware works very nicely,
and out-performs 10.2 in my testing.  Lots of people use my firmware
when they need IBSS support or other features not found in
official firmware, so it is not just me that will have
problems if you remove this support.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

