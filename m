Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64967 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab0DWEyV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 00:54:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 21:54:21 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19409.10214.121368.607913@gargle.gargle.HOWL>
Date: Fri, 23 Apr 2010 10:23:58 +0530
To: Ming Lei <tom.leiming@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/9] ath9k_htc: Use USB reboot
In-Reply-To: <j2nd82e647a1004220721n4668229l51c6e27a21ec9f8c@mail.gmail.com>
References: <19407.50660.739033.942199@gargle.gargle.HOWL>
	<j2nd82e647a1004220721n4668229l51c6e27a21ec9f8c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ming Lei wrote:
> The buffer passed to usb hcd should not be allocated from stack since
> it will be DMAed to usb host controller. The 'cmd' should be allocated by
> kmalloc even though it is only 4byte.

Indeed, I'll send an updated patch.

Sujith
