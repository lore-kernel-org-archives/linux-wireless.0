Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56804 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab0EKTzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 15:55:12 -0400
Message-ID: <4BE9B61A.2090708@openwrt.org>
Date: Tue, 11 May 2010 21:55:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/4] ath9k: add debugfs files for reading/writing the
 rx and tx chainmask
References: <1273591383-76696-1-git-send-email-nbd@openwrt.org> 	<1273591383-76696-2-git-send-email-nbd@openwrt.org> <AANLkTilDwhBErduNt_vZLSsEVVkC1SDMwUPkoumym1o3@mail.gmail.com>
In-Reply-To: <AANLkTilDwhBErduNt_vZLSsEVVkC1SDMwUPkoumym1o3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-11 8:15 PM, Luis R. Rodriguez wrote:
> On Tue, May 11, 2010 at 8:23 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> How about we use bruno's patch instead and we help review it for
> 802.11n? Then this would not be needed?
I'd like to keep those separate. I've seen cards where the wrong
chainmask was programmed into the eeprom, this debugfs file is for
detecting that and trying other settings.
When Bruno's patch gets implemented for ath9k, the values that it can
set should be masked by the internal value, while the debugfs file can
override the internal value.

- Felix
