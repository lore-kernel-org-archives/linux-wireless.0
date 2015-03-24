Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:46759 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbbCXMBy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:01:54 -0400
Message-ID: <55114C85.60703@compulab.co.il> (sfid-20150324_130200_099766_28806401)
Date: Tue, 24 Mar 2015 13:37:41 +0200
From: Nikita Kiryanov <nikita@compulab.co.il>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
CC: Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Javier Martinez Canillas <javier@dowhile0.org>
Subject: Re: [PATCH v7 0/6] wlcore: add device-tree support
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
In-Reply-To: <1426696710-6891-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On 03/18/2015 06:38 PM, Eliad Peller wrote:
> Add device-tree support to the wlcore (wl12xx/wl18xx)
> driver.
>
> Update the current users to use the bindings instead
> of pdata-quirks.
>
> Finally, remove the deprecated wl12xx_platform_data
> struct (along with the da850 board file code that
> still uses it)

Tested-by: Nikita Kiryanov <nikita@compulab.co.il>
Tested on am437x-gp-evm with WL1835MODCOM8B

-- 
Regards,
Nikita Kiryanov
