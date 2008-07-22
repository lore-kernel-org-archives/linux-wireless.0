Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:49183 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYGVQys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 12:54:48 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1468326ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 09:54:46 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [GIT PATCH] rfkill fixes, set 2, v2
Date: Tue, 22 Jul 2008 19:11:26 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807221911.26708.IvDoorn@gmail.com> (sfid-20080722_185452_196336_E04B8800)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 July 2008, Henrique de Moraes Holschuh wrote:
> 
> Here is the updated version, with all requested corrections.
> 
> Ivo, please check if they're as you wanted in the patches still missing
> your acked-by (patches 3, 5).

They look good. Thanks for the update. :)

> There is one extra minor doc-fix patch, patch 6.  I found I somehow sent
> an older version for merge (d3d682041a15f69cd335172041a8393e878521e9
> "rfkill: some minor kernel-doc changes for rfkill_toggle_radio"), and
> since I had the fix lying around...
> 
> Henrique de Moraes Holschuh (6):
>       rfkill: document rfkill_force_state as required (v2)
>       rfkill: fix led-trigger unregister order in error unwind
>       rfkill: document the rfkill struct locking (v2)
>       rfkill: mutex fixes
>       rfkill: query EV_SW states when rfkill-input (re)?connects to a input device
>       rfkill: yet more minor kernel-doc fixes
> 
> Please consider for merging for 2.6.27-rc1, as they are fixes and not
> enhancements.
> 
> Patches based on wireless-testing master.                                                                                                            

Ivo
