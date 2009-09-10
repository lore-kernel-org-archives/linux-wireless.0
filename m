Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58397 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZIJSiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 14:38:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] b43: Force-wake queues on init
Date: Thu, 10 Sep 2009 20:38:15 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Albert Herranz <albert_herranz@yahoo.es>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
References: <200909102031.47103.mb@bu3sch.de> <43e72e890909101134j64bf22eai1c282cc1738cd968@mail.gmail.com>
In-Reply-To: <43e72e890909101134j64bf22eai1c282cc1738cd968@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909102038.17930.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 September 2009 20:34:36 Luis R. Rodriguez wrote:
> On Thu, Sep 10, 2009 at 11:31 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > Force wake the mac80211 queues on init.
> > Under rare circumstances they may be stopped, if a DMA error or
> > something else causes a device reset while a queue was stopped.
> 
> So this is a work around for some unknown issue on the driver?

No, it's a fix for a bug that should not trigger in practice very often.

-- 
Greetings, Michael.
