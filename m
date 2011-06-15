Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab1FOUsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 16:48:09 -0400
Received: by wya21 with SMTP id 21so603132wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 13:48:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTik2PGhQh9=ZTfm2MXHdKSMVqNPfXg@mail.gmail.com>
References: <BANLkTik2PGhQh9=ZTfm2MXHdKSMVqNPfXg@mail.gmail.com>
Date: Wed, 15 Jun 2011 13:48:07 -0700
Message-ID: <BANLkTi=zAEX_sqKidE6rSKKgORr5MRYmpw@mail.gmail.com> (sfid-20110615_224815_147537_5B9A091E)
Subject: mwifiex & P2P (aka WiFi Direct)
From: Liam <pubsub@networkimprov.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're integrating a module based on the Marvell SD8787 into an
embedded Linux device. We need to enable P2P/WFD on this device.

I see no refs to P2P in the mwifiex README, but there is
vendor-provided code ('wfd' command) to configure this subsystem.

Is anyone implementing the "socket control interface" P2P primitives,
or other low-level API to P2P, in mwifiex?

If not, I have the choice of either adding such an API to mwifiex, or
using vendor-provided driver code which presumably isn't as
well-vetted as mwifiex. Any guidance?

Liam Breck
Menlo Park, CA
