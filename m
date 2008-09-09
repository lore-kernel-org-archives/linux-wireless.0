Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbYIIAhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 20:37:24 -0400
Subject: Re: [PATCH] b43legacy: Fix to enhance TX speed
From: David Woodhouse <dwmw2@infradead.org>
To: gavron@wetwork.net
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <48C358C8.3080607@wetwork.net>
References: <48C358C8.3080607@wetwork.net>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 19:37:23 -0500
Message-Id: <1220920643.5748.22.camel@shinybook.infradead.org> (sfid-20080909_023728_962253_C7E2F555)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-09-06 at 21:30 -0700, gavron@wetwork.net wrote:
> Recent changes in the specifications have improved the performance
> of the BCM4306/2 devices that use b43legacy as the driver. These
> "errors" in the specs have been present from the very first
> implementation of bcm43xx.

I haven't verified any speed improvement, but certainly this patch (when
applied on top of the Fedora 9 kernel) doesn't make my shinybook get bus
errors, which has been a common problem when updating this part of the
code to match the specs.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

