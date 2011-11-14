Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59268 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab1KNVdy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 16:33:54 -0500
Subject: Re: iwlagn 3.0.9 aggreggation messages
From: wwguy <wey-yi.w.guy@intel.com>
To: Lars Schotte <gusto@guttok.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111114221847.2ca32e6a@hana.gusto>
References: <20111114131642.31e8ddbd@hana.gusto>
	 <1321283410.13578.33.camel@wwguy-ubuntu>
	 <20111114201947.58d5fdf6@hana.gusto>	<1321303101.1796.8.camel@wwguy-ubuntu>
	 <20111114221847.2ca32e6a@hana.gusto>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 13:27:40 -0800
Message-ID: <1321306060.1796.13.camel@wwguy-ubuntu> (sfid-20111114_223403_935974_D81F9AD5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could you try with the following module parameter and see if it help?

$modprobe iwlwifi auto_agg=0

Thanks
Wey

On Mon, 2011-11-14 at 13:18 -0800, Lars Schotte wrote:
> of course he deactivates the aggregation soon after, because the AP
> sees no reason why there should be one.
> 
> triggering the aggreggation is that problem and it exists only since
> 3.0.9. 3.0.8 is OK, but 3.1.1 seems to be affected as well. 3.1.0 was
> OK.
> 
> so someting broke it recently.
> 
> unfortunately i can not remember if 3.2 kernel had that problem, i
> already removed it because it was too unstable for me, so i can not
> test it any more (w/o compiling it again).
> 
> On Mon, 14 Nov 2011 12:38:21 -0800
> wwguy <wey-yi.w.guy@intel.com> wrote:
> 
> > Hi Schotte,
> > 
> > looks like driver has problem activate the aggregation, you can see in
> > the log, the aggregation queue being activate then deactivate soon
> > after. that is why you are seeing the messages showing up in dmesg
> > log.
> > 
> > what AP you are using? is similar thing happen if you connect to
> > different AP?
> > 
> > Thanks
> > Wey
> 
> 


