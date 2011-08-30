Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35908 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1H3KrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 06:47:16 -0400
Received: by yie30 with SMTP id 30so4257940yie.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 03:47:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110830104403.GA5446@vmraj-lnx.users.atheros.com>
References: <1314605174-66206-1-git-send-email-nbd@openwrt.org>
	<CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com>
	<4E5B669F.8060605@dti2.net>
	<20110830104403.GA5446@vmraj-lnx.users.atheros.com>
Date: Tue, 30 Aug 2011 18:47:15 +0800
Message-ID: <CAJ-VmomDSZ+PL=-Vc+Gbz7FoST=_MJ7_F0O5avNv-sefJTzP2g@mail.gmail.com> (sfid-20110830_124719_755739_397E92BF)
Subject: Re: [PATCH 3.1] ath9k_hw: fix calibration on 5 ghz
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 August 2011 18:44, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:

> Could you please test whether the below patch helps?
>
> https://patchwork.kernel.org/patch/1112672/

FreeBSD does this. nbd disabled the EEPROM check a while ago in ath9k.
So it isn't this.



Adrian
