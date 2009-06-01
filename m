Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:46133 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZFAWxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 18:53:25 -0400
Received: by pxi29 with SMTP id 29so3016638pxi.33
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 15:53:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243819768.3623.438.camel@debian>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	<20090526222433.GA23972@bombadil.infradead.org> <1243736227.3623.180.camel@debian>
	<43e72e890905302327x23d0479bkb825ea05832c5ffd@mail.gmail.com>
	<1243752126.3623.375.camel@debian> <1243771847.5248.10.camel@maxim-laptop>
	<1243819768.3623.438.camel@debian>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Jun 2009 15:52:10 -0700
Message-ID: <43e72e890906011552x7a140c5bt18ca05f2352a2955@mail.gmail.com>
Subject: Re: [Announce] Intel Wireless Multicomm 3200 WiFi driver
To: Zhu Yi <yi.zhu@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 31, 2009 at 6:29 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Sun, 2009-05-31 at 20:10 +0800, Maxim Levitsky wrote:
>> This is a fullmac driver, thus if I understand correctly, it behaves
>> on the outside more like an Ethernet adapter.
>
> Depends on how you define "outside". From the user point of view: yes;
> from the firmware point of view: no. Take a look at the new functions
> ieee80211_data_{from|to}_8023 in cfg80211 and their usage in
> iwmc3200wifi.
>
>> This will mean that many things possible with normal softmac card
>> won't be possible, like sending raw packets, etc...
>
> See above.
>
>> (and besides I belive that hardware is more or less the same,
>
> The hardware is different as we mentioned it is a multicomm device.

What does this mean BTW. 802.11 + Wimax?

  Luis
