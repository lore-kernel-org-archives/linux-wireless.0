Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29220 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1H3Kng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 06:43:36 -0400
Date: Tue, 30 Aug 2011 16:14:04 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
CC: <adrian@freebsd.org>, Felix Fietkau <nbd@openwrt.org>,
	<linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 3.1] ath9k_hw: fix calibration on 5 ghz
Message-ID: <20110830104403.GA5446@vmraj-lnx.users.atheros.com> (sfid-20110830_124340_299807_BB60C2C8)
References: <1314605174-66206-1-git-send-email-nbd@openwrt.org>
 <CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com>
 <4E5B669F.8060605@dti2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <4E5B669F.8060605@dti2.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 12:14:55PM +0200, Jorge Boncompte [DTI2] wrote:
> El 29/08/2011 11:01, Adrian Chadd escribió:
> > Can we please hold off of this until we know if this is indeed the correct fix?
> > 
> > Ie, I'm not sure yet whether 5ghz fast clock (which clocks the mac/bb
> > like it was doing 2.4ghz) needs the dual ADCs enabled or not.
> > It may be that something is being incorrectly disabled when the
> > fastclock initvals are being written over the normal 5ghz values.
> >uary
> > Thanks,
> 
> 	Hi, I reported this same problem on february, I was using Ubiquiti SR71-15
> cards. I've been running them with the same "fix" that Felix has proposed. If
> you need a tester for another solution just let me know.
> 
Hi Jorge,

Could you please test whether the below patch helps?

https://patchwork.kernel.org/patch/1112672/

Thanks,
Rajkumar
