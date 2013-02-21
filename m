Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34768 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3BUCGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 21:06:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20773.32951.976684.849906@gargle.gargle.HOWL> (sfid-20130221_030622_947568_6D6CDD4C)
Date: Thu, 21 Feb 2013 07:34:39 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
In-Reply-To: <51258020.1060906@candelatech.com>
References: <511935F2.8080103@candelatech.com>
	<20761.34987.125000.908722@gargle.gargle.HOWL>
	<511BC243.8010409@candelatech.com>
	<20770.57339.20017.225929@gargle.gargle.HOWL>
	<51255360.6060603@candelatech.com>
	<20773.31273.604966.176099@gargle.gargle.HOWL>
	<51258020.1060906@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Powersave is always disabled in our tests...can't use it with multiple VIFS
> as far as I know...

Ah, yes.

> System doesn't recover if we drop the attenuation back to optimal levels, btw.

Ok.

Sujith
