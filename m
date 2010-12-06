Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0LFLvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 06:51:46 -0500
Subject: Re: [PATCH V2 12/27] ath9k_hw: Find chansel of
 AR_PHY_65NM_CH0_SYNTH7 from an array for AR9485
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101206114401.GT12908@vasanth-laptop>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
	 <1291288031-3409-13-git-send-email-vasanth@atheros.com>
	 <4CF84BB8.8090007@openwrt.org> <20101203045054.GP12908@vasanth-laptop>
	 <4CF8DF08.2060307@openwrt.org> <20101203124050.GR12908@vasanth-laptop>
	 <4CF8E718.9070207@openwrt.org> <20101206060310.GS12908@vasanth-laptop>
	 <4CFCBE04.7070509@openwrt.org>  <20101206114401.GT12908@vasanth-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 12:51:40 +0100
Message-ID: <1291636300.3506.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-06 at 17:14 +0530, Vasanthakumar Thiagarajan wrote:

> #define CHANSEL_2G_9485(_freq) ((((freq) * 0x10000) - 215) / CHANSEL_DIV)
>  for (i = 0; i < 14; i++) {
>                freq = 2412 + (i * 5);

This is not correct for channel 14.

johannes

