Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32701 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0DZQmT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 12:42:19 -0400
Subject: Re: iwl3945: Error sending REPLY_{RXON|SCAN_CMD|TX_PWR_TABLE_CMD}
 time out after 500ms
From: reinette chatre <reinette.chatre@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <k2i2d0a357f1004260931l98ce66d2ia3422958779c64d7@mail.gmail.com>
References: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
	 <1271782442.14052.19698.camel@rchatre-DESK>
	 <s2j2d0a357f1004210006gc964e5edl672ec5406b892a9@mail.gmail.com>
	 <1271883056.4381.1743.camel@rchatre-DESK>
	 <m2s2d0a357f1004260120z30d8b3a3i2792cfa4bc390dcc@mail.gmail.com>
	 <1272298097.4381.8765.camel@rchatre-DESK>
	 <k2i2d0a357f1004260931l98ce66d2ia3422958779c64d7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 09:42:18 -0700
Message-ID: <1272300138.4381.8815.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 09:31 -0700, Sedat Dilek wrote:
> I tested both .34-git4 kernels half a day and this was the only
> problem I saw in the my system-logs.

This may indicate a problem in your environment since it just says that
the station cannot communicate with the AP anymore. This occurs very
often in various environments. This does not indicate a bug.

> BTW, the WLAN connection did not crash as described in the initial
> bug-report (logs see [1]).
> At that time, I had to coldstart my machine - this was not the case
> last weekend while testing.

Either this issue is very hard to reproduce or it has been addressed
with a change introduced between the kernels you are testing. Can you
reproduce the issue when going back to earlier kernels? If so, then this
may be a candidate for a bisect for us to find out what fixed it. 

Reinette

