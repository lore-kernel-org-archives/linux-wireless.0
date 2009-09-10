Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:35692 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbZIJSex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 14:34:53 -0400
Received: by iwn8 with SMTP id 8so160493iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 11:34:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909102031.47103.mb@bu3sch.de>
References: <200909102031.47103.mb@bu3sch.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Sep 2009 11:34:36 -0700
Message-ID: <43e72e890909101134j64bf22eai1c282cc1738cd968@mail.gmail.com>
Subject: Re: [PATCH] b43: Force-wake queues on init
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Albert Herranz <albert_herranz@yahoo.es>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 11:31 AM, Michael Buesch <mb@bu3sch.de> wrote:
> Force wake the mac80211 queues on init.
> Under rare circumstances they may be stopped, if a DMA error or
> something else causes a device reset while a queue was stopped.

So this is a work around for some unknown issue on the driver?

  Luis
