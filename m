Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21358 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0EKUOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 16:14:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 13:14:22 -0700
Date: Tue, 11 May 2010 13:14:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/4] ath9k: add debugfs files for reading/writing the
 rx and tx chainmask
Message-ID: <20100511201420.GC24447@tux>
References: <1273591383-76696-1-git-send-email-nbd@openwrt.org>
 <1273591383-76696-2-git-send-email-nbd@openwrt.org>
 <AANLkTilDwhBErduNt_vZLSsEVVkC1SDMwUPkoumym1o3@mail.gmail.com>
 <4BE9B61A.2090708@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4BE9B61A.2090708@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 12:55:06PM -0700, Felix Fietkau wrote:
> On 2010-05-11 8:15 PM, Luis R. Rodriguez wrote:
> > On Tue, May 11, 2010 at 8:23 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > 
> > How about we use bruno's patch instead and we help review it for
> > 802.11n? Then this would not be needed?
> I'd like to keep those separate. I've seen cards where the wrong
> chainmask was programmed into the eeprom, this debugfs file is for
> detecting that and trying other settings.
> When Bruno's patch gets implemented for ath9k, the values that it can
> set should be masked by the internal value, while the debugfs file can
> override the internal value.

Fair enough, thanks.

  Luis
