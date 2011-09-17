Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:54892 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1IQFxz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 01:53:55 -0400
Date: Sat, 17 Sep 2011 07:53:54 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: problem with intel 5300
In-Reply-To: <alpine.DEB.2.00.1109102219380.13829@uplift.swm.pp.se>
Message-ID: <alpine.DEB.2.00.1109170753250.13829@uplift.swm.pp.se> (sfid-20110917_075359_353700_BC48144E)
References: <alpine.DEB.2.00.1109100736280.13538@uplift.swm.pp.se> <1315667365.3547.20.camel@wwguy-huron> <alpine.DEB.2.00.1109102219380.13829@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 10 Sep 2011, Mikael Abrahamsson wrote:

> On Sat, 10 Sep 2011, Guy, Wey-Yi wrote:
>
>> 2. use module parameter wd_disable=1 to avoid firmware reload and go
>> into "deep sleep"
>
> I'm going with number 2 here, will report back if it didn't work.

When I try that, I get:

iwlagn: Unknown parameter `wd_disable'

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
