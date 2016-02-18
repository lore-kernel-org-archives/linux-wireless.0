Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45130 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425796AbcBRUIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:08:47 -0500
Message-ID: <1455826121.2084.17.camel@sipsolutions.net> (sfid-20160218_210909_946479_89E66720)
Subject: Re: [PATCH 7/9] rfkill: Create "rfkill-airplane_mode" LED trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Thu, 18 Feb 2016 21:08:41 +0100
In-Reply-To: <1454946096-9752-8-git-send-email-jprvita@endlessm.com> (sfid-20160208_164147_435264_67EE08E5)
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
	 <1454946096-9752-8-git-send-email-jprvita@endlessm.com>
	 (sfid-20160208_164147_435264_67EE08E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-08 at 10:41 -0500, João Paulo Rechi Vita wrote:
> This creates a new LED trigger to be used by platform drivers as a
> default trigger for airplane-mode indicator LEDs.
> 
> By default this trigger will fire when RFKILL_OP_CHANGE_ALL is called
> for all types (RFKILL_TYPE_ALL), setting the LED brightness to
> LED_FULL
> when the changing the state to blocked, and to LED_OFF when the
> changing
> the state to unblocked. In the future there will be a mechanism for
> userspace to override the default policy, so it can implement its
> own.
> 
> This trigger will be used by the asus-wireless x86 platform driver.

Just one comment - I think you should be consistent with the _ vs - and
just use "rfkill-airplane-mode" as the name.

johannes
