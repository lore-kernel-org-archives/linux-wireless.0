Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab1KNPQZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 10:16:25 -0500
Subject: Re: iwlagn 3.0.9 aggreggation messages
From: wwguy <wey-yi.w.guy@intel.com>
To: Lars Schotte <gusto@guttok.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111114131642.31e8ddbd@hana.gusto>
References: <20111114131642.31e8ddbd@hana.gusto>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 07:10:10 -0800
Message-ID: <1321283410.13578.33.camel@wwguy-ubuntu> (sfid-20111114_161628_766884_3DFC4290)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lars,

On Mon, 2011-11-14 at 04:16 -0800, Lars Schotte wrote:
> hi,
> 
> i get always such aggreggation messages every 35 seconds since the
> update from 3.0.8 to 3.0.9, so something is wrong there.
> 
> [  238.280312] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0
> because load = 0 [  335.575672] iwlagn 0000:02:00.0:
> iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [  400.605027]
> iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid
> = 0 [  532.418136] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra =
> 20:4e:7f:5b:2d:f5 tid = 0 [  590.173035] iwlagn 0000:02:00.0:
> iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [  616.193084]
> iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid
> = 0 [  934.882300] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra =
> 20:4e:7f:5b:2d:f5 tid = 0 [  983.877888] iwlagn 0000:02:00.0:
> iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 1048.354089]
> iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid
> = 0 [ 1137.254697] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra =
> 20:4e:7f:5b:2d:f5 tid = 0 [ 1173.956035] iwlagn 0000:02:00.0:
> iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0

hmm, it should not happen, are you still seeing this in the latest
driver? if does, could you load the driver with debug flag = 0x43fff to
help us understand what is happening?

> 
> then there are no iwlagn drivers in 3.2 any more, but iwlwifi, what's
> the difference between these two drivers?
> 
We are in the process of re-architect and improve the flexible and
quality of our existing driver. As today, "iwlwifi" should the same as
"iwlagn" and you can use either one (iwlwifi or iwlagn), "iwlagn" just
an alias of "iwlwifi". Moving forward, we will deprecate the "iwlagn"
name after we complete the implementation of next generation of Intel
WiFi driver.

Thanks
Wey
 


