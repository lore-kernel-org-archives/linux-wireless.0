Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:59784 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab1KNVUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 16:20:53 -0500
Date: Mon, 14 Nov 2011 22:18:47 +0100
From: Lars Schotte <gusto@guttok.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn 3.0.9 aggreggation messages
Message-ID: <20111114221847.2ca32e6a@hana.gusto> (sfid-20111114_222055_921959_AF01E22A)
In-Reply-To: <1321303101.1796.8.camel@wwguy-ubuntu>
References: <20111114131642.31e8ddbd@hana.gusto>
	<1321283410.13578.33.camel@wwguy-ubuntu>
	<20111114201947.58d5fdf6@hana.gusto>
	<1321303101.1796.8.camel@wwguy-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

of course he deactivates the aggregation soon after, because the AP
sees no reason why there should be one.

triggering the aggreggation is that problem and it exists only since
3.0.9. 3.0.8 is OK, but 3.1.1 seems to be affected as well. 3.1.0 was
OK.

so someting broke it recently.

unfortunately i can not remember if 3.2 kernel had that problem, i
already removed it because it was too unstable for me, so i can not
test it any more (w/o compiling it again).

On Mon, 14 Nov 2011 12:38:21 -0800
wwguy <wey-yi.w.guy@intel.com> wrote:

> Hi Schotte,
> 
> looks like driver has problem activate the aggregation, you can see in
> the log, the aggregation queue being activate then deactivate soon
> after. that is why you are seeing the messages showing up in dmesg
> log.
> 
> what AP you are using? is similar thing happen if you connect to
> different AP?
> 
> Thanks
> Wey


-- 
Lars Schotte
@ Hana (F16)
