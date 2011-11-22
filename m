Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52812 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1KVWKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 17:10:12 -0500
Received: by bke11 with SMTP id 11so794940bke.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 14:10:10 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Michael Basse <michael@alpha-unix.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Re: [PATCH] rt2800pci: handle spurious interrupts
Date: Tue, 22 Nov 2011 23:10:07 +0100
Message-ID: <1700561.mj30bDeLIf@helmutmobil.site> (sfid-20111122_231016_775816_B2DA4274)
In-Reply-To: <4ECC071E.5050403@alpha-unix.de>
References: <20111116100915.GA2191@redhat.com> <4ECC071E.5050403@alpha-unix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 22. November 2011, 21:33:34 schrieb Michael Basse:
> Hopefully your patch is fixing the issues we are facing.

Why do you think the panics are produced by rt2800pci? The stacktraces
attached to https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869502
don't show rt2x00 related functions ...

Helmut
