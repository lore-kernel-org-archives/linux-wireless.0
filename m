Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51840 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0GHUOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 16:14:15 -0400
MIME-Version: 1.0
In-Reply-To: <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B7@dbde02.ent.ti.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-16-git-send-email-ohad@wizery.com> <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B7@dbde02.ent.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 8 Jul 2010 23:13:52 +0300
Message-ID: <AANLkTikAq9wgsfxP7LMObEMuaNM9YjhDfk9MzK8tLoXs@mail.gmail.com>
Subject: Re: [PATCH 15/15] omap: zoom: enable WLAN device
To: "Ghorai, Sukumar" <s-ghorai@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, "Ben-cohen, Ohad" <ohadb@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 8, 2010 at 6:39 AM, Ghorai, Sukumar <s-ghorai@ti.com> wrote:
> [Ghorai] In general we can avoid OMAP_ZOOM_WLAN and MMC_EMBEDDED_SDIO as kconfig option. 1st one is board specific and 2nd one could be generic sdio code. As I mentioned in other patch too.


Thanks, will get rid of the extra config options.


>> --
>> 1.7.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
