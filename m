Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27363 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0LNQZQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 11:25:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 08:25:01 -0800
Date: Tue, 14 Dec 2010 08:25:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH] ath9k: Make PM-QOS value as user configurable
Message-ID: <20101214162513.GC6190@tux>
References: <1292312908-6182-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1292312908-6182-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 13, 2010 at 11:48:28PM -0800, Mohammed Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> This patch allows the pm-qos value to be user configurable by making it as
> a module parameter.This will help our customers to configure the pm-qos
> value according to the effect in throughput due to the DMA latency problem
> which was observed in Intel Pinetrail platforms.
> 	The tested value of '55' will be filled as the default
> pm-qos-value incase the user does not specifies pm-qos value as a
> module parameter.
> example usage: sudo modprobe ath9k pmqos=65

Where is this documented though? Can you please add some

/*
 * some good docs
 */

of some sort as a followup patch? Thanks!

  Luis
