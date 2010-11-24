Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38209 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab0KXQ7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 11:59:09 -0500
Received: by gwj20 with SMTP id 20so911304gwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 08:59:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290592410.25710.4.camel@chilepepper>
References: <1290438027-20179-1-git-send-email-luciano.coelho@nokia.com>
 <1290438027-20179-2-git-send-email-luciano.coelho@nokia.com>
 <AANLkTinrKyw-EHKrt5WKbHjbiQUM7Vhz3MR3n8OdWpzf@mail.gmail.com> <1290592410.25710.4.camel@chilepepper>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 24 Nov 2010 08:58:48 -0800
Message-ID: <AANLkTi=pPT84kCOzEbUX+5nTwn4tM=Z-kmYae9Nirv-1@mail.gmail.com>
Subject: Re: [PATCH 1/1] compat-wireless: apply changes needed after
 wl1271->wl12xx renaming
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 1:53 AM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> Hi Luis,
>
>
> On Mon, 2010-11-22 at 10:13 -0800, ext Luis R. Rodriguez wrote:
>> On Mon, Nov 22, 2010 at 7:00 AM,  <luciano.coelho@nokia.com> wrote:
>> > From: Luciano Coelho <luciano.coelho@nokia.com>
>> >
>> > This patch changes the occurrences of wl1271 in the Makefile, README and in
>> > the scripts to wl12xx, since the driver has been renamed.
>> >
>> > Also remove the wl1271_ prefix from the filenames.
>> >
>> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
>>
>> Applied and pushed, thanks!
>
> It seems that the wl12xx file name changes are now in linux-next.  I
> guess it's okay to include this patch in compat-wireless now.
>
> Sorry for the trouble!

Its already there, thanks!

  Luis
