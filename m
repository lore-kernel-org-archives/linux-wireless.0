Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:49107 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYKSPJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 10:09:03 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1387595eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 07:09:01 -0800 (PST)
Message-ID: <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com> (sfid-20081119_160908_487944_055F7344)
Date: Wed, 19 Nov 2008 17:09:01 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
In-Reply-To: <1227106146.26243.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com>
	 <1226943608.3902.36.camel@johannes.berg>
	 <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com>
	 <1227106146.26243.43.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
Thanks for your answer.

Now, after looking at the API doc ,  It seems to me that sequence
numbering is also missing in the zd1211rw driver.

Regards,
Rami Rosen


On Wed, Nov 19, 2008 at 4:49 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-19 at 15:59 +0200, Rami Rosen wrote:
>
>> Two examples:
>> 1.1) In the link below it says: "ZD1211 can operate in the mode of
>> station and access point."
>> http://linux.softpedia.com/get/System/Hardware/ZD1211-Driver-12712.shtml
>
> Maybe it can.
>
>> - Can you please elaborate a bit about how can we know whether a
>> device support or does not support multicast buffering ?
>
> I have no idea. At minimum, the driver needs to do what the wiki says:
> http://wireless.kernel.org/en/developers/Documentation/mac80211/API
> You'll also want to read the 802.11 docs about this.
>
>> - Could it be that some zd1211 chipsets do support multicast
>> buffering, and some do not ?
>
> Doubt it, they all use the same firmware.
>
> johannes
>
