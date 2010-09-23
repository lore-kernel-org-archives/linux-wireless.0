Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40155 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0IWMam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 08:30:42 -0400
Date: Thu, 23 Sep 2010 15:29:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board
 file
Message-ID: <20100923122937.GP4580@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
 <20100923114528.GL4580@legolas.emea.dhcp.ti.com>
 <1285244253.3231.75.camel@chilepepper>
 <20100923122048.GO4580@legolas.emea.dhcp.ti.com>
 <1285244908.3231.77.camel@chilepepper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <1285244908.3231.77.camel@chilepepper>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Sep 23, 2010 at 07:28:28AM -0500, Luciano Coelho wrote:
>Ah, I see.  Thanks for the explanation.  I guess we could do that in a
>separate patch.  The zoom board file already uses this .irq element, so
>this patch would not be the appropriate place to change it.
>
>Is it okay if I deal with that after I'm done with the current patch?

sure :-)

-- 
balbi
