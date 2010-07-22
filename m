Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33655 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0GVAcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 20:32:50 -0400
Message-ID: <4C4791AF.8040909@openwrt.org>
Date: Thu, 22 Jul 2010 02:32:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: performance regressions / tx semi-stuck
 somehow
References: <AANLkTimQ7O2nOmh2Rda3d_PKWbS2WlGVBHYMCuhxW10W@mail.gmail.com>
In-Reply-To: <AANLkTimQ7O2nOmh2Rda3d_PKWbS2WlGVBHYMCuhxW10W@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-22 12:17 AM, Björn Smedman wrote:
> Hi all,
> 
> I just tried out compat-wireless-2010-07-16 on AR913x (with
> openwrt/trunk@r22321) and saw some weird performance problems.
> 
> That's in exactly the same spot I was getting 16Mbps consistently with
> AP was 11n!
> 
> Any debuging I can do to help? Bisecting is unfortunately a lot of
> work on this embedded system...
Could you please try if the earlier version that was in OpenWrt
(2010-07-06) has the same issues?

- Felix
