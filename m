Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55507 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab0JSJIE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 05:08:04 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 02:07:54 -0700
Message-ID: <4CBD5FE6.5050409@atheros.com>
Date: Tue, 19 Oct 2010 14:37:50 +0530
From: Bala Shanmugam <sbalashanmugam@atheros.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Shanmugamkamatchi Balashanmugam
	<Shanmugamkamatchi.Balashanmugam@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Do not compile staging directory for bt target. Signed-off-by:
 Bala Shanmugam <sbalashanmugam@atheros.com>
References: <1287477938-7684-1-git-send-email-sbalashanmugam@atheros.com> <AANLkTimoMhytXWm9qh21VGX5B6EoE6JwWyMu1t-ivno9@mail.gmail.com>
In-Reply-To: <AANLkTimoMhytXWm9qh21VGX5B6EoE6JwWyMu1t-ivno9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 10/19/2010 2:23 PM, Luis R. Rodriguez wrote:
> Applied, you may want a ./scripts/driver-select entry as well.
>
>    Luis
Not needed for now as we have seperate targets to compile, install and 
uninstall bluetooth modules.

Bala.
