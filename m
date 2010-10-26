Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31313 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab0JZRUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 13:20:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 10:20:33 -0700
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 26 Oct 2010 22:46:00 +0530
Subject: RE: [PATCH] ath9k_htc: Set proper firmware offset for AR7010 devices
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C7@CHEXMB-01.global.atheros.com>
References: <1288104164-18940-1-git-send-email-rmanoharan@atheros.com>,<AANLkTin+TtPKtOgWd2+BZyYLpP4Jagv4u68CALjBNc7G@mail.gmail.com>
In-Reply-To: <AANLkTin+TtPKtOgWd2+BZyYLpP4Jagv4u68CALjBNc7G@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>On Tue, Oct 26, 2010 at 7:42 AM, Rajkumar Manoharan
><rmanoharan@atheros.com> wrote:
>> This patch handles the firmware loading properly for
> >AR7010 HTC devices.

>This description is vague, you could have said instead that it treats
>0x9018 as a AR7010.
>
> Luis

0x9018 was already treated as AR7010 devices. But it is missed in firmware offset
selection. I'll resend the patch. Thanks for pointing out Luis :)

- Rajkumar