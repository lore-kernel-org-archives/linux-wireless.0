Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53027 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab0A2IXY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 03:23:24 -0500
Message-ID: <4B629AF5.40706@openwrt.org>
Date: Fri, 29 Jan 2010 09:23:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: rootkit85@yahoo.it, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org
Subject: Re: [ath9k-devel] Significiant performance differences between ath5k
  and ath9k in 802.11a
References: <256732.66854.qm@web51401.mail.re2.yahoo.com>
In-Reply-To: <256732.66854.qm@web51401.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-29 9:10 AM, Joerg Pommnitz wrote:
> --- rootkit85@yahoo.it <rootkit85@yahoo.it> wrote:
> 
>> 
>> Can you try in AP-client mode? I think you'll get more
>> throughput so.
>> 
> 
> No, IBSS is what I'm interested in. And the point is, that there is
> a 30% performance difference between ath5k (and Madwifi) and ath9k. Even
> if the performance in AP mode would be better, this does not change the
> problem in IBSS mode.
I can confirm these numbers for AP/Client mode as well. I've even tested
legacy communication between ath9k ap and sta, producing the same
result. Additionally, I can rule out the rate control algorithm, as
using minstrel instead of the ath9k RC produces a very similar
throughput test result.

- Felix
