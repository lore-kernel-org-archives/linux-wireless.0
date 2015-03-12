Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10603 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbbCLNUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:20:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: add symlink for hwmon device
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1424437452-28161-3-git-send-email-rmanohar@qti.qualcomm.com>
	<87pp8gyi7x.fsf@kamboji.qca.qualcomm.com>
	<20150310164223.GA11700@qca.qualcomm.com>
Date: Thu, 12 Mar 2015 15:20:33 +0200
In-Reply-To: <20150310164223.GA11700@qca.qualcomm.com> (Rajkumar Manoharan's
	message of "Tue, 10 Mar 2015 22:12:26 +0530")
Message-ID: <878uf2uzby.fsf@kamboji.qca.qualcomm.com> (sfid-20150312_142045_421569_1031753E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> On Tue, Mar 10, 2015 at 05:39:46PM +0200, Kalle Valo wrote:
>> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
>> 
>> > Add symbloic link "thermal_sensors" for hwmon devices for better
>> > readability.
>> >
>> > /sys/class/ieee80211/phyX/device/thermal_sensors ->
>> > sys/class/ieee80211/phyX/device/hwmon/hwmonY
>> 
>> I don't get it, how does that improve readability? Also I don't see any
>> other driver doing this, so isn't this just some private hack and not a
>> proper generic interface?
>
> The patch is providing same level access to monitoring device similar to
> cooling device.
>
> cooling_device -> ../../../../../virtual/thermal/cooling_deviceX
> thermal_sensors -> hwmon/hwmonX

Is this documented somewhere? We cannot just start inventing sysfs
interfaces on our own.

-- 
Kalle Valo
