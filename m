Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:55978 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbYFEJoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 05:44:30 -0400
Date: Thu, 5 Jun 2008 11:43:43 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Tomas Winkler <tomasw@gmail.com>
Cc: maximilian attems <max@stro.at>, linux-wireless@vger.kernel.org
Subject: Re: Page allocation failure in 2.6.26-rc2 (iwl4965 driver)
Message-ID: <20080605094343.GG5012@ics.muni.cz> (sfid-20080605_114434_470021_282B67E2)
References: <20080604130307.GN5012@ics.muni.cz> <20080604130452.GD9258@baikonur.stro.at> <20080604185743.GQ5012@ics.muni.cz> <1ba2fa240806041209i5e3fbb35r5667314ea9417379@mail.gmail.com> <1ba2fa240806050154w6bee2f08n80031e09ac12e9ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <1ba2fa240806050154w6bee2f08n80031e09ac12e9ed@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 05, 2008 at 11:54:36AM +0300, Tomas Winkler wrote:
> Actually I've already posted the patch that fixes allocation. It' jus=
t
> not in rc2
> http://marc.info/?l=3Dlinux-wireless&m=3D121205035427353&w=3D2

unfortnately, it does not fix my allocation failure as that failure is =
caused
by kmalloc allocation tx_queue which is struct size * TFD_QUEUE_SIZE_MA=
X
large.

--=20
Luk=E1=B9 Hejtm=E1nek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
