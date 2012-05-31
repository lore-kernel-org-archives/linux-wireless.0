Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57913 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2EaGhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 02:37:08 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20423.4426.500293.813699@gargle.gargle.HOWL> (sfid-20120531_083713_227358_32B72808)
Date: Thu, 31 May 2012 12:05:54 +0530
To: Ben Greear <greearb@candelatech.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Ath9k performance testing results (AR9380)
In-Reply-To: <4FC6FF1B.7050201@candelatech.com>
References: <4FC55443.4020003@candelatech.com>
	<20422.56339.579488.464864@gargle.gargle.HOWL>
	<4FC6FF1B.7050201@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> On 05/30/2012 07:48 PM, Sujith Manoharan wrote:
> > Ben Greear wrote:
> >> I am not sure why there is such a big difference, but possibly
> >> sending wifi is harder than receiving it, and the Atom processor
> >> just can't keep up.
> >
> > I have a small Atom-based netbook, I'll try with it and see what numbers
> > can be seen. It's a pain to pry it open and bolt a different card, though. :)
> 
> We had to install a hacked 'white-listed' BIOS to get a Lenovo laptop to even POST with
> an Atheros NIC in it, so if your NIC works w/out having to hack the BIOS, please
> let me know :)

It works on Samsung netbooks. I replaced the onboard card with a AR9462 card
and there were no hiccups.

Sujith
