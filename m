Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:34546 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964787Ab1GOK4O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 06:56:14 -0400
To: Gery Kahn <geryk@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 2/2] wl12xx Export chip id to sysfs
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
	<1310647673-10144-2-git-send-email-geryk@ti.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 15 Jul 2011 13:56:12 +0300
In-Reply-To: <1310647673-10144-2-git-send-email-geryk@ti.com> (Gery Kahn's message of "Thu\, 14 Jul 2011 15\:47\:53 +0300")
Message-ID: <874o2nx16b.fsf@purkki.adurom.net> (sfid-20110715_125617_553053_B039FBDD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gery Kahn <geryk@ti.com> writes:

> Export the chip id to userspace. This helps to change application behavior
> according to architecture of the wl12xx chip.

We already support exporting this type of information through
ethtool's ioctl interface using the wiphy.hw_version, which was
specifially added for this purpose. That's much better than yet
another sysfs file.

-- 
Kalle Valo
