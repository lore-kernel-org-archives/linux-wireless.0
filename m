Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36653 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZAEKcw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 05:32:52 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 02:32:51 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18785.57618.47120.669270@gargle.gargle.HOWL> (sfid-20090105_113313_753468_18A1652B)
Date: Mon, 5 Jan 2009 15:59:38 +0530
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: [RFC 08/12] ath9k: get EEPROM contents from platform data on AHB bus
In-Reply-To: <1230990262-22923-9-git-send-email-juhosg@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
	<1230990262-22923-9-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> +#ifndef _LINUX_ATH9K_PLATFORM_H
> +#define _LINUX_ATH9L_PLATFORM_H

Typo ?

Also, after addressing Christopher's comments, I don't think too many
bus specific routines would remain. In that case would it be reasonable
to just have a single file (bus.c, with appropriate ifdefs), instead
of pci.c and ahb.c ?

Sujith
