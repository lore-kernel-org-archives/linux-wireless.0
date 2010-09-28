Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55771 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab0I1Xk3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 19:40:29 -0400
Message-ID: <4CA27CE5.8010303@openwrt.org>
Date: Wed, 29 Sep 2010 01:40:21 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k and virtual APs?
References: <4CA26AC5.2040407@candelatech.com>
In-Reply-To: <4CA26AC5.2040407@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-29 12:23 AM, Ben Greear wrote:
> We are able to create multiple APs on ath9k, but they don't appear to
> be fully working.
> 
> Before I go start digging, is anyone aware of what needs to happen
> to get ath9k supporting multiple APs properly?
Worked for me last time I tried it. I've been using that feature on
OpenWrt for a while. If it really is broken now, it must be recent breakage.

- Felix
