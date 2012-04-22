Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.multi.fi ([85.134.37.151]:60134 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2DVJl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 05:41:58 -0400
Received: from tmb-laptop.supernet (55863541.cust.multi.fi [85.134.53.65] (may be forged))
	by smtp.multi.fi (8.14.4/8.14.4) with ESMTP id q3M9fqpp006143
	for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 12:41:54 +0300
Message-ID: <4F93D264.6060905@mageia.org> (sfid-20120422_114233_785565_3325E47D)
Date: Sun, 22 Apr 2012 12:41:56 +0300
From: Thomas Backlund <tmb@mageia.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Missing iwlwifi firmwares ?
References: <4F932A3D.2070701@mageia.org>  (sfid-20120421_235812_903118_31B5AB43) <1335045596.6516.8.camel@jlt3.sipsolutions.net>  <4F9332EE.3030106@mageia.org> <1335054866.27767.172.camel@wwguy-huron>
In-Reply-To: <1335054866.27767.172.camel@wwguy-huron>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

22.04.2012 03:34, Guy, Wey-Yi skrev:
> it is already in the iwlwifi tree 
>  http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=summary
> 
> From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> Date: Wed, 11 Apr 2012 11:33:36 -0700
> Subject: [PATCH 1/1] iwlwifi: use correct released ucode version
> 
> Report correctly the latest released version
> of the iwlwifi firmware for all
> iwlwifi-supported devices.
> 
> Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> I will push it to 3.4 tomorrow.
> 
> Thanks
> Wey


Found it, thanks!

btw, shouldn't that patch have a cc: stable@ for atleast 3.3 ?

--
Thomas

