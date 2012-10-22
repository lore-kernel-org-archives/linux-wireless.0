Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60182 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab2JVVpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 17:45:09 -0400
Message-ID: <5085BE64.6030802@openwrt.org> (sfid-20121022_234514_110066_905A251F)
Date: Mon, 22 Oct 2012 23:45:08 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Cannot bring up second VAP on recent kernels?
References: <5085AA78.1080809@candelatech.com> <5085B866.8060306@openwrt.org> <5085BA0E.6080903@candelatech.com>
In-Reply-To: <5085BA0E.6080903@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-22 11:26 PM, Ben Greear wrote:
> On 10/22/2012 02:19 PM, Felix Fietkau wrote:
>> On 2012-10-22 10:20 PM, Ben Greear wrote:
>>> Anyone successfully using more than one virtual AP on
>>> 3.3 or higher kernels?  It works fine for me on 3.0.32,
>>> but my 3.3.8 and 3.5.7 kernels (and a few similar ones)
>>> all fail with errors like this below:
>>>
>>> Hardware is ath9k 3x3 9380 NIC.
>> Are you using one hostapd instance per vap, or one hostapd instance for
>> all of them?
> 
> One hostapd per VAP.
I had issues with that a long time ago. Use one hostapd instance for all
vaps on the same wiphy, that'll work better.

- Felix

