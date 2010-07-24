Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:25344 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab0GXCCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 22:02:35 -0400
Subject: Re: ath9k - D-link DWA-552
From: Pavel Roskin <proski@gnu.org>
To: Andy Pyles <andy.pyles@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTil3u8uFbH7WyPuvqu0wee4KsojqPUsAH2kupZhJ@mail.gmail.com>
References: <AANLkTil3u8uFbH7WyPuvqu0wee4KsojqPUsAH2kupZhJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 22:02:25 -0400
Message-ID: <1279936945.27462.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-21 at 14:58 -0400, Andy Pyles wrote:
> I have recently purchased two of these cards. ( the markings on the
> outside indicate they have are same hardware revision). I am noticing
> some strange behavior on one of them:
...
> $lspci -n output:
> 05:05.0 0200: 168c:ff1d (rev 01)

This looks like some experimental version that was not meant to be sold.

> Has anyone else seen this behavior with Card Two? I tried swapping to
> a different PCI slot, even to a different PC.
> Same symptom. I also tried modifying pci.c in ath9k driver to no effect.

If you add the PCI ID to the driver, something should change.  The
driver would try to initialize the card.  If it fails, you should get
some message in the kernel log, which can be seen by running dmesg.

-- 
Regards,
Pavel Roskin
