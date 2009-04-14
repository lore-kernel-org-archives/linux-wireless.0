Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out7.libero.it ([212.52.84.107]:37730 "EHLO
	cp-out7.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZDNPOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 11:14:48 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: [PATCH 2/3] p54: more SoftLED updates
Date: Tue, 14 Apr 2009 17:12:33 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200903250312.18264.chunkeey@web.de>
In-Reply-To: <200903250312.18264.chunkeey@web.de>
MIME-Version: 1.0
Message-Id: <200904141712.34220.rossi.f@inwind.it> (sfid-20090414_171452_036771_88319E01)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 March 2009, Christian Lamparter wrote:

> This patch hopefully finishes the SoftLED code:
> - It adds two more LEDs (rx and radio).
>   (the FW claims it can support up to 16 LEDs,
>    but I doubt that any vendor put more than 4 on a board)
> - update the LEDs in a _delayed_ workqueue.
>   No one reported any more crashes.
>   (see: "PATCH] p54: fix race condition in memory management")
>   So we can stop burning the mm code.

My device has 2 LEDs and I can see 4 registrations (assoc, tx, rx and radio). 
Does it make sense to register LEDs which are not available?

Fabio
