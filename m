Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63748 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab0CVFBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 01:01:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 21 Mar 2010 22:01:20 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19366.65089.541041.18060@gargle.gargle.HOWL>
Date: Mon, 22 Mar 2010 10:51:05 +0530
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [ath9k_htc] Wrong kernel config parameters in wiki?
In-Reply-To: <2d0a357f1003191828g2d133a06qd8902785ae015cd0@mail.gmail.com>
References: <2d0a357f1003191828g2d133a06qd8902785ae015cd0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sedat Dilek wrote:
> Hi,
> 
> a person asked on IRC about ath9k_htc support.
> 
> First question:
> Has the patch from [1] already entered one of the wireless-* GIT repositories?

Nope, the driver has not been merged yet.
A revised series (12 patches) was submitted.
They should be available on patchwork.

> I could apply the ath9k_htc patch against 2.6.34-rc1-git9.
> 
> The kernel config parameters in wiki [2] seems to be wrong to me:
> 
> CONFIG_ATH=m
> CONFIG_ATH9K_HW=m
> CONFIG_ATH9K_HTC=m

Yep, they are wrong and are fixed now.

Sujith
