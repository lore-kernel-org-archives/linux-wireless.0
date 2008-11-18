Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:50163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYKRKsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 05:48:52 -0500
Message-ID: <49229D90.4090004@scherping.de> (sfid-20081118_114906_404970_F5EAA63A)
Date: Tue, 18 Nov 2008 11:48:48 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: linux-wireless@vger.kernel.org, Luis.Rodriguez@Atheros.com
Subject: Re: [PATCH 05/18] ath9k: Remove half/quarter rate tables
References: <18722.14321.337217.549326@gargle.gargle.HOWL>
In-Reply-To: <18722.14321.337217.549326@gargle.gargle.HOWL>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith schrieb:
> Half/Quarter rate tables are needed only for legacy chipsets.

Does this also mean that Atheros 11n cards are not capable of 10 MHz channel bandwith operation (CHANNEL_HALF)?
10 MHz channels do work in ath5k with Ahteros 11a / 11abg chipsets, which is e.g. helpful for basic IEEE 802.11p operation.

Richard
