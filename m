Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55416 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582Ab1FPXMC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 19:12:02 -0400
Message-ID: <4DFA8DBF.9080301@openwrt.org> (sfid-20110617_011207_790459_4133D119)
Date: Fri, 17 Jun 2011 01:11:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k WDS panic without CONFIG_ATH9K_RATE_CONTROL
References: <4DF93116.700@gnu.org> <4DF96668.3040007@openwrt.org> <4DFA7BAD.7060405@gnu.org>
In-Reply-To: <4DFA7BAD.7060405@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-16 11:54 PM, Pavel Roskin wrote:
> On 06/15/2011 10:11 PM, Felix Fietkau wrote:
>
>>  Some time ago I sent some patches to fix the issues with WDS (and add
>>  support for HT, including aggregation).
>>
>>  These patches assume that you set up an AP on both sides alongside the
>>  WDS interface (beacons of the APs are used to exchange rates and
>>  capabilities).
>
> I think WDS should work without beacons.  At least the basic rates
> should be available when the interface is brought up.  Further changes
> to the set of supported rates can be made with iw.
>
> WDS is somewhat orthogonal to the beacons.  The beacons are primarily
> meant for the stations.
For 802.11n you need proper HT capabilites anyway. I think it usually 
doesn't make much sense to use WDS without AP interfaces, but if you 
consider it worth adding support for, then please build your patches on 
top of my patch series.

- Felix
