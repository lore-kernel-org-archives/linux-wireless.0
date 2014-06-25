Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:38570 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaFYBKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 21:10:08 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: tiwai@suse.de, leedom@chelsio.com, cocci@systeme.lip6.fr,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RESEND][PATCH 3/3] p54: use request_firmware_direct() for optional EEPROM override
Date: Wed, 25 Jun 2014 03:10:02 +0200
Message-ID: <1582751.494RL7XPxB@blech> (sfid-20140625_031038_389025_99A8110D)
In-Reply-To: <1403649583-12707-4-git-send-email-mcgrof@do-not-panic.com>
References: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com> <1403649583-12707-4-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 24, 2014 03:39:43 PM Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> The p54 driver uses request_firmware() twice, once for actual
> firmware and then another time for an optional user overide on
> EEPROM, 3826.eeprom. The custom EEPROM  is optional but if not
> present we'll introduce an extra lag of 60 seconds with udev
> present. Annotate we don't want udev nonsense here to avoid
> the lag in case its not present.
> [...]
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: cocci@systeme.lip6.fr
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Acked-By: Christian Lamparter <chunkeey@googlemail.com>

