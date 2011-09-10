Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:48505 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab1IJUVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 16:21:06 -0400
Date: Sat, 10 Sep 2011 22:21:05 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: problem with intel 5300
In-Reply-To: <1315667365.3547.20.camel@wwguy-huron>
Message-ID: <alpine.DEB.2.00.1109102219380.13829@uplift.swm.pp.se> (sfid-20110910_222119_587875_F48D6433)
References: <alpine.DEB.2.00.1109100736280.13538@uplift.swm.pp.se> <1315667365.3547.20.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 10 Sep 2011, Guy, Wey-Yi wrote:

> Here are two possible solution and work-around and please give a try
> 1. apply the patch I attach and see if it help
> 2. use module parameter wd_disable=1 to avoid firmware reload and go
> into "deep sleep"

I'm going with number 2 here, will report back if it didn't work.

Thanks!

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
