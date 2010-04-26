Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38256 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0DZRE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 13:04:26 -0400
Received: by wyb42 with SMTP id 42so57210wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 10:04:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1272300138.4381.8815.camel@rchatre-DESK>
References: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
	 <1271782442.14052.19698.camel@rchatre-DESK>
	 <s2j2d0a357f1004210006gc964e5edl672ec5406b892a9@mail.gmail.com>
	 <1271883056.4381.1743.camel@rchatre-DESK>
	 <m2s2d0a357f1004260120z30d8b3a3i2792cfa4bc390dcc@mail.gmail.com>
	 <1272298097.4381.8765.camel@rchatre-DESK>
	 <k2i2d0a357f1004260931l98ce66d2ia3422958779c64d7@mail.gmail.com>
	 <1272300138.4381.8815.camel@rchatre-DESK>
Date: Mon, 26 Apr 2010 19:04:23 +0200
Message-ID: <i2w2d0a357f1004261004l93447d00oa4ca674795437d4c@mail.gmail.com>
Subject: Re: iwl3945: Error sending REPLY_{RXON|SCAN_CMD|TX_PWR_TABLE_CMD}
	time out after 500ms
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 26, 2010 at 6:42 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Mon, 2010-04-26 at 09:31 -0700, Sedat Dilek wrote:
>> I tested both .34-git4 kernels half a day and this was the only
>> problem I saw in the my system-logs.
>
> This may indicate a problem in your environment since it just says that
> the station cannot communicate with the AP anymore. This occurs very
> often in various environments. This does not indicate a bug.
>
>> BTW, the WLAN connection did not crash as described in the initial
>> bug-report (logs see [1]).
>> At that time, I had to coldstart my machine - this was not the case
>> last weekend while testing.
>
> Either this issue is very hard to reproduce or it has been addressed
> with a change introduced between the kernels you are testing. Can you
> reproduce the issue when going back to earlier kernels? If so, then this
> may be a candidate for a bisect for us to find out what fixed it.
>

The kernel (with patches) is identical to the one from 20100417, so
what shall I bisect?
With same kernel-config, etc.
But in the meantime I upgraded my system - it could be that some other
package(s) fixed the magic.
Other idea could be some temporarily occured disturbance in WLAN
connection and/or in streaming on the websites I visited.

- Sedat -
