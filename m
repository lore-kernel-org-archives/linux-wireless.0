Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34428 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2FGRus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 13:50:48 -0400
Message-ID: <4FD0E9EA.4090704@qca.qualcomm.com> (sfid-20120607_195051_348648_14DEAF52)
Date: Thu, 7 Jun 2012 20:50:34 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [RFC 1/2] nl80211: specify RSSI threshold when scanning
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com> <1339084251.2434.2.camel@dcbw.foobar.com>
In-Reply-To: <1339084251.2434.2.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 06:50 PM, Dan Williams wrote:
> On Wed, 2012-06-06 at 19:43 -0700, Thomas Pedersen wrote:
>> Support configuring an RSSI threshold in dBm (s32) when scanning,
>> below which a BSS won't be reported by the cfg80211 driver.
> 
> What's the point of this?  Shouldn't the driver report all available
> APs, even if the signal is small, and then userspace (or whatever is
> handling scan results) just ignores ones it doesn't care about?

When you do this on the firmware you can reduce host wakeups and hence
save power.

Kalle
