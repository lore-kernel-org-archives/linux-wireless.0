Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35895 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039Ab1FPVy5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 17:54:57 -0400
Message-ID: <4DFA7BAD.7060405@gnu.org> (sfid-20110616_235500_460032_E2A27A31)
Date: Thu, 16 Jun 2011 17:54:53 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k WDS panic without CONFIG_ATH9K_RATE_CONTROL
References: <4DF93116.700@gnu.org> <4DF96668.3040007@openwrt.org>
In-Reply-To: <4DF96668.3040007@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2011 10:11 PM, Felix Fietkau wrote:

> Some time ago I sent some patches to fix the issues with WDS (and add
> support for HT, including aggregation).
>
> These patches assume that you set up an AP on both sides alongside the
> WDS interface (beacons of the APs are used to exchange rates and
> capabilities).

I think WDS should work without beacons.  At least the basic rates 
should be available when the interface is brought up.  Further changes 
to the set of supported rates can be made with iw.

WDS is somewhat orthogonal to the beacons.  The beacons are primarily 
meant for the stations.

-- 
Regards,
Pavel Roskin
