Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6860 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1H3LsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 07:48:25 -0400
Date: Tue, 30 Aug 2011 17:18:53 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
CC: <adrian@freebsd.org>, Felix Fietkau <nbd@openwrt.org>,
	<linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 3.1] ath9k_hw: fix calibration on 5 ghz
Message-ID: <20110830114852.GA6524@vmraj-lnx.users.atheros.com> (sfid-20110830_134829_406705_38F3E35C)
References: <1314605174-66206-1-git-send-email-nbd@openwrt.org>
 <CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com>
 <4E5B669F.8060605@dti2.net>
 <20110830104403.GA5446@vmraj-lnx.users.atheros.com>
 <CAJ-VmomDSZ+PL=-Vc+Gbz7FoST=_MJ7_F0O5avNv-sefJTzP2g@mail.gmail.com>
 <4E5CC904.8000003@dti2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <4E5CC904.8000003@dti2.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 01:27:00PM +0200, Jorge Boncompte [DTI2] wrote:
> El 30/08/2011 12:47, Adrian Chadd escribió:
> > On 30 August 2011 18:44, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> > 
> >> Could you please test whether the below patch helps?
> >>
> >> https://patchwork.kernel.org/patch/1112672/
> > 
> > FreeBSD does this. nbd disabled the EEPROM check a while ago in ath9k.
> > So it isn't this.
> > 
> 
> 	Yes, it is not.
> 

Thanks Jorge.

--
Rajkumar
