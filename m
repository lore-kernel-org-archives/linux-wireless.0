Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:55298 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZH0VgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:36:00 -0400
Received: by iwn42 with SMTP id 42so745747iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 14:36:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251408741.22482.14.camel@johannes.local>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
	<1251406807-31495-14-git-send-email-luciano.coelho@nokia.com>
	<1251408741.22482.14.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 27 Aug 2009 14:35:42 -0700
Message-ID: <43e72e890908271435t3b873a9pc6c2fc69a0cba5ca@mail.gmail.com>
Subject: Re: [PATCH 13/13] wl1271: added Juuso Oikarinen as module author
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <luciano.coelho@nokia.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 2:32 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-08-28 at 00:00 +0300, Luciano Coelho wrote:
>> Add Juuso as one of the module authors, since he's working heavily on this
>> module as well.
>>
>> Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
>> ---
>>  drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
>> index a97d434..4163eac 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
>> @@ -1449,4 +1449,5 @@ module_init(wl1271_init);
>>  module_exit(wl1271_exit);
>>
>>  MODULE_LICENSE("GPL");
>> -MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
>> +MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>, "
>> +           "Juuso Oikarinen <juuso.oikarinen@nokia.com>");
>
> Use multiple MODULE_AUTHORs instead.

Where is that defined?

  Luis
