Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44825 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbbCJQmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:42:47 -0400
Date: Tue, 10 Mar 2015 22:12:26 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: add symlink for hwmon device
Message-ID: <20150310164223.GA11700@qca.qualcomm.com> (sfid-20150310_174250_828679_6884AD44)
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1424437452-28161-3-git-send-email-rmanohar@qti.qualcomm.com>
 <87pp8gyi7x.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87pp8gyi7x.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2015 at 05:39:46PM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Add symbloic link "thermal_sensors" for hwmon devices for better
> > readability.
> >
> > /sys/class/ieee80211/phyX/device/thermal_sensors ->
> > sys/class/ieee80211/phyX/device/hwmon/hwmonY
> 
> I don't get it, how does that improve readability? Also I don't see any
> other driver doing this, so isn't this just some private hack and not a
> proper generic interface?
>
The patch is providing same level access to monitoring device similar to
cooling device.

cooling_device -> ../../../../../virtual/thermal/cooling_deviceX
thermal_sensors -> hwmon/hwmonX

-Rajkumar
