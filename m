Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44357 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2EMNqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 09:46:19 -0400
Received: by wgbdr13 with SMTP id dr13so3832382wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2012 06:46:18 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harry <Habstinat@gmail.com>
Subject: Re: carl9170 - Unable to see interface despite module being loaded
Date: Sun, 13 May 2012 15:46:13 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20120513T054053-18@post.gmane.org>
In-Reply-To: <loom.20120513T054053-18@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201205131546.13765.chunkeey@googlemail.com> (sfid-20120513_154623_767633_4E43950D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 May 2012 05:59:01 Harry wrote:
> I own a "Bus 001 Device 002: ID 0cf3:7015 Atheros Communications, Inc. TP-Link
> TL-WN821N v3 802.11n [Atheros AR7010+AR9287]", according to lsusb. I'm
> attempting to get the carl9170 (
> http://linuxwireless.org/en/users/Drivers/carl9170 ) driver to work with it, as
> should be possible according to h-node ( http://www.h-node.org/wifi/view/en/253/
> ) in Parabola GNU/Linux.

Well looks like you figured it out already?!
Anyway, TP-Link changed the chipset with the v3 series.
 - the 3-4 years old V1 and V2 revisions have the AR9170
	chip and are supported by carl9170.
 - V3 and newer need a different driver: ath9k_htc
	<http://wireless.kernel.org/en/users/Drivers/ath9k_htc>

Regards,
	Chr
