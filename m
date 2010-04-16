Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26785 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757804Ab0DPLcq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 07:32:46 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 04:32:46 -0700
Subject: Re: [ath9k-devel] [RFC][PATCH 2/6] ath9k: do not mark frames with
 RXKEY_IX_INVALID as decrypted
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Johan Hovold <johan.hovold@lundinova.se>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1271415135-18317-2-git-send-email-johan.hovold@lundinova.se>
References: <20100416104850.GA13329@lundinova.se>
	 <1271415135-18317-2-git-send-email-johan.hovold@lundinova.se>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 14:32:41 +0300
Message-ID: <1271417561.8066.4.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 03:52 -0700, Johan Hovold wrote:
> Frames tagged by hardware with ATH9K_RXKEYIX_INVALID should not
> incorrectly be marked decrypted (even if key index in frame is valid).

Have you tested this with static WEP configuration? Or broadcast RX with
WPA? There must be a reason for that odd looking code being there in the
first place and I can now only think of it being needed when the default
keys are used.

- Jouni


