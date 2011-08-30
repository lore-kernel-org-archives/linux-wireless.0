Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:40693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1H3L1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 07:27:50 -0400
Received: from alcalazamora.dti2.net (alcalazamora.dti2.net [81.24.162.8])
	by hera.kernel.org (8.14.4/8.14.3) with ESMTP id p7UBR71B021961
	for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 11:27:08 GMT
Received: from [172.16.16.6] ([81.24.161.20])
	(authenticated user jorge@dti2.net)
	by alcalazamora.dti2.net (alcalazamora.dti2.net [81.24.162.8])
	(MDaemon PRO v12.0.3)
	with ESMTP id md50018385707.msg
	for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 13:27:06 +0200
Message-ID: <4E5CC904.8000003@dti2.net> (sfid-20110830_132754_331714_E13C8BEE)
Date: Tue, 30 Aug 2011 13:27:00 +0200
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
MIME-Version: 1.0
To: adrian@freebsd.org
CC: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 3.1] ath9k_hw: fix calibration on 5 ghz
References: <1314605174-66206-1-git-send-email-nbd@openwrt.org> <CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com> <4E5B669F.8060605@dti2.net> <20110830104403.GA5446@vmraj-lnx.users.atheros.com> <CAJ-VmomDSZ+PL=-Vc+Gbz7FoST=_MJ7_F0O5avNv-sefJTzP2g@mail.gmail.com>
In-Reply-To: <CAJ-VmomDSZ+PL=-Vc+Gbz7FoST=_MJ7_F0O5avNv-sefJTzP2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Reply-To: jorge@dti2.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 30/08/2011 12:47, Adrian Chadd escribió:
> On 30 August 2011 18:44, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> 
>> Could you please test whether the below patch helps?
>>
>> https://patchwork.kernel.org/patch/1112672/
> 
> FreeBSD does this. nbd disabled the EEPROM check a while ago in ath9k.
> So it isn't this.
> 

	Yes, it is not.

-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- There is only so much duct tape you can put on something
  before it just becomes a giant ball of duct tape.
==============================================================

