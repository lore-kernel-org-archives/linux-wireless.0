Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35568 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbZHBKne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 06:43:34 -0400
Received: by bwz19 with SMTP id 19so1973195bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 03:43:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249199143.2007.2.camel@johannes.local>
References: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
	 <1249171448.3491.32.camel@localhost.localdomain>
	 <1ba2fa240908012249s348a2412wca21de44f9b8cb71@mail.gmail.com>
	 <1249199143.2007.2.camel@johannes.local>
Date: Sun, 2 Aug 2009 13:43:33 +0300
Message-ID: <1ba2fa240908020343j7308e215vc1914244c8cd191a@mail.gmail.com>
Subject: Re: [PATCH 1/1] rfkill: add the GPS radio type
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 2, 2009 at 10:45 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Sun, 2009-08-02 at 08:49 +0300, Tomas Winkler wrote:
>
>> > we don't have a GPS subsystem, but even without it, I think this is a
>> > good thing to have.
>>
>> GPS devices are usually serial devices.
>
> Yeah, this is interesting -- do we want something like /dev/urfkill
> (cf. /dev/uinput), so that gpsd or whatever is controlling the GPS (same
> applies for 3G) can be controlled with rfkill?

Sorry don't know much about /dev/uinput what is difference between
/dev/urfkill and /dev/rfkill, can you be, please more verbose
Thanks
Tomas
