Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:57069 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYFXQ74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 12:59:56 -0400
Received: by yx-out-2324.google.com with SMTP id 31so548357yxl.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 09:59:55 -0700 (PDT)
Message-ID: <1ba2fa240806240959q398c324al9d9c009c218c0489@mail.gmail.com> (sfid-20080624_190001_306215_52E9AD26)
Date: Tue, 24 Jun 2008 19:59:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Kalle Valo" <kalle.valo@iki.fi>
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
Cc: "Michael Buesch" <mb@bu3sch.de>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <87vdzzdj5m.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
	 <200806241242.11727.mb@bu3sch.de>
	 <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com>
	 <87vdzzdj5m.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 5:03 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Tomas Winkler <tomasw@gmail.com> writes:
>
>>> What about b-only devices?
>>
>> See the log message...(known issue). Currently you have to loop over
>> rates to get this info. I wasn't sure if they are any b-only NICs
>> under mac80211 so I didn't run to implement it.
>
> at76_usb will be 11b only mac80211 driver whenever we manage to
> complete the port.
>
> --
> Kalle Valo
>

Then pls, look at the V2 of this patch if this work for you.
Thanks
Tomas
