Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47345 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYIFRPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 13:15:31 -0400
Subject: Re: [PATCH] Ath9k: Add RF kill support.
From: Marcel Holtmann <marcel@holtmann.org>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 19:15:47 +0200
Message-Id: <1220721347.6714.114.camel@californication> (sfid-20080906_191538_728310_1EC0FE5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasanthakumar,

> CONFIG_ATH9K_RFKILL needs to be set
> to enable this support.

why do we have to introduce yet another config option for this? What is
the advantage of disabling RFKILL support? I really don't see it and all
these extra config options are rather confusing than useful.

Regards

Marcel


