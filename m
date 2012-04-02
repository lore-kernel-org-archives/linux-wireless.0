Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:50449 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752671Ab2DBQxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 12:53:40 -0400
Message-ID: <1333385618.15422.17.camel@joe2Laptop> (sfid-20120402_185357_911076_96B0A5DB)
Subject: Re: CONFIG_RTLWIFI_DEBUG default y
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 02 Apr 2012 09:53:38 -0700
In-Reply-To: <20120402164920.GA13264@x1.osrc.amd.com>
References: <20120402164920.GA13264@x1.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-02 at 18:49 +0200, Borislav Petkov wrote:
> Err,

Not Err...

> why is RTLWIFI_DEBUG default to y? This is an option for driver
> developers only AFAICT and should be default n.

To keep all the "printk(KERN_DEBUG" to "pr_debug(" conversion
output the same as the it was prior to the patch.

Larry can default it to off if he wants.

cheers, Joe

