Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34065 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0BIEW2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 23:22:28 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 20:22:28 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19312.59210.947966.773343@gargle.gargle.HOWL>
Date: Tue, 9 Feb 2010 10:10:42 +0530
To: Kalle Valo <kalle.valo@iki.fi>
CC: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix PAE frame handling
In-Reply-To: <87d40ljov0.fsf@purkki.valot.fi>
References: <4B65F735.1020509@openwrt.org>
	<19302.24837.154697.822430@gargle.gargle.HOWL>
	<87d40ljov0.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Any more information about the problem? For example, what APs are
> broken?
> 
> I'm just wondering if we should see this with other hardware also.

Internal test cycles exposed this problem where certain APs didn't
handle properly PAE frames being part of an aggregate.

I'll see if I can dig up the APs from the test results.

Sujith
