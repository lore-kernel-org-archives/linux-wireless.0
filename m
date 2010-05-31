Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:18532 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756640Ab0EaK0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 06:26:11 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0892821566
	for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 19:26:07 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Peter Chubb <peter.chubb@nicta.com.au>
Subject: Re: Commit 6b5d,.. breaks ath5k in WPA-enabled networks
Date: Mon, 31 May 2010 19:26:34 +0900
Cc: me@bobcopeland.com, linux-wireless@vger.kernel.org
References: <w47hmkh1b4.wl%peter@chubb.wattle.id.au>
In-Reply-To: <w47hmkh1b4.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005311926.34371.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 31 May 2010 18:23:43 Peter Chubb wrote:
> With Linus's current head-of-tree my ath5k cannot associate with
> WPA-enabled access points.  I bisected back to this patch:
> 
> 	    Since commit 6b5d117eddc09cd976ad8030d715f4350f598a22
> 	    ath5k: clean up queue manipulation
> 
> I suspect at least one of the two wake-up calls that were removed is
> actually necessary.
> 
> Reverting the patch restores correct behaviour.

try this, please:

https://patchwork.kernel.org/patch/100681/

i have sent the patch a long time ago but it didnt get merged yet.

bruno

> --
> Dr Peter Chubb                                  peter DOT chubb AT
> nicta.com.au http://www.ertos.nicta.com.au               ERTOS within
> National ICT Australia All things shall perish from under the sky/Music
> alone shall live, never to die --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
