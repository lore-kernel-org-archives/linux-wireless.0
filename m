Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1CBN5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 08:57:30 -0500
Subject: Re: [PATCH] linux-firmware: Initial release for Bluetooth init
 script
From: David Woodhouse <dwmw2@infradead.org>
To: Gery Kahn <gery.kahn@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>
In-Reply-To: <1299072814-11660-1-git-send-email-geryk@ti.com>
References: <1299072814-11660-1-git-send-email-geryk@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 13:57:26 +0000
Message-ID: <1299074246.24834.30.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 15:33 +0200, Gery Kahn wrote:
> 
>  WHENCE                            |   12 ++++++++++++
>  ti-connectivity/TIInit_7.2.31.bts |  Bin 0 -> 48909 bytes 

Does this live in /lib/firmware or in /lib/firmware/ti-connectivity?

If the former, please don't put the actual file in a subdirectory. If
the latter, your comment in the WHENCE file is wrong.

-- 
dwmw2

