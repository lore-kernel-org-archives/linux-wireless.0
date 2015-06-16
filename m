Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42342 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbbFPBZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 21:25:09 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21887.31486.302760.504336@gargle.gargle.HOWL> (sfid-20150616_032514_069799_18815C7B)
Date: Tue, 16 Jun 2015 06:55:18 +0530
To: Arend van Spriel <arend@broadcom.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>,
	"Felix Fietkau" <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] ath9k: advertise p2p dev support when chanctx
In-Reply-To: <557F1716.3040204@broadcom.com>
References: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com>
	<21886.43539.833126.629494@gargle.gargle.HOWL>
	<CALhHN=pUKuXAEb3JEEVTHATEHhvoLe52QDh-pixiS9oUo=6j6Q@mail.gmail.com>
	<21886.62363.946771.345441@gargle.gargle.HOWL>
	<557F1716.3040204@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel wrote:
> The p2p-device is designed to be used for p2p discovery and p2p action 
> frame exchange. It make it easier for driver and/or firmware to 
> determine if user-space request is p2p related or not. However, in 
> discussions with Jouni I got the impression that ath (or qca) firmware 
> and/or drivers did not need this design. Not sure if that claim is 
> unaffected by the "use_chanctx=1" parameter.

Thanks for the explanation.

I don't think advertising support for p2p-device is required for
ath9k. P2P discovery works properly with the normal station/ap interface
types and the 'use_chanctx' modparam simply enables multiple channel
contexts.

Sujith
