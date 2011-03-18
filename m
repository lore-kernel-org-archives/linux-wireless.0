Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53034 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab1CRQFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 12:05:30 -0400
Received: by iyb26 with SMTP id 26so4126499iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 09:05:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110318135058.GE5103@tuxdriver.com>
References: <1300417820-19029-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTi=58JJNoYG7232ykiOnAK2TX18ROxrfYQir3Wwe@mail.gmail.com> <20110318135058.GE5103@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 18 Mar 2011 09:05:10 -0700
Message-ID: <AANLkTi=jnL3EO3CDw8KEePnA7+xQZ9JBBDHcPCGsDKD9@mail.gmail.com>
Subject: Re: [RTF] iwmc3200wifi: fix device registration ordering for cfg80211
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, vmehta@atheros.com,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	devel@linuxdriverproject.org, naveen.singh@atheros.com,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 6:50 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Mar 17, 2011 at 08:11:17PM -0700, Luis R. Rodriguez wrote:
>> On Thu, Mar 17, 2011 at 8:10 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > Without this you can get a race against udev and userspace daemons
>> > which will try to poke the device even before netdev ops and friends
>> > are available. Device initialization will fail without this.
>> >
>> > Cc: stable@kernel.org
>> > Cc: Naveen Singh <nsingh@atheros.com>
>> > Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>> > Cc: Intel Linux Wireless <ilw@linux.intel.com>
>> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> > ---
>>
>> Oops sorry, this was supposed to go to Linville.
>
> And probably "[RFT]" instead of "[RTF]" too. :-)

Heh yes, sorry been WTF'ing a bit too much lately.

> Does anyone even have this hardware?
