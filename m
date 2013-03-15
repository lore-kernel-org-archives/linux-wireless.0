Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34739 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab3COWVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 18:21:54 -0400
Message-ID: <51439F00.9050001@openwrt.org> (sfid-20130315_232158_895714_8B2AFEC8)
Date: Fri, 15 Mar 2013 23:21:52 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.9] ath9k: limit tx path hang check to normal data queues
References: <1363360724-44435-1-git-send-email-nbd@openwrt.org> <20130315183457.GB2676@bombadil.infradead.org>
In-Reply-To: <20130315183457.GB2676@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-15 7:34 PM, Luis R. Rodriguez wrote:
> On Fri, Mar 15, 2013 at 04:18:44PM +0100, Felix Fietkau wrote:
>> The beacon and multicast-buffer queues are managed by the beacon
>> tasklet, and the generic tx path hang check does not help in any way
>> here. Running it on those queues anyway can introduce some race
>> conditions leading to unnecessary chip resets.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> This applies to v3.8 as well, do you want it there as well?
Yes

