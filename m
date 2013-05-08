Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33187 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3EHFIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 01:08:35 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20873.56643.216380.594657@gargle.gargle.HOWL> (sfid-20130508_070849_636552_0003DE7E)
Date: Wed, 8 May 2013 10:36:11 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fun with QoS in AP mode.
In-Reply-To: <5189DB72.3020809@candelatech.com>
References: <5189DB72.3020809@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> We were doing some testing with ToS/QoS in some VOIP streams today.
> 
> The mappings on the station machine work fine, but on the AP, the packets
> always go to the BE queue.  Both systems are 3.9.0+ ath9k, recent hostapd,
> supplicant, etc.

Is the AP running ath9k ?

Sujith
