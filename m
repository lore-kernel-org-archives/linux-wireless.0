Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:51295 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdI1QIg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Sep 2017 12:08:36 -0400
Received: by mail-qk0-f169.google.com with SMTP id 18so1877200qkt.8
        for <linux-wireless@vger.kernel.org>; Thu, 28 Sep 2017 09:08:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1506613923.8795.1.camel@sipsolutions.net>
References: <CADsGw2Zax=r7QBGYPO+bs0BTmb+JUVZ-Y-X+_gfRrKj8tQy27Q@mail.gmail.com>
 <1506613011.8795.0.camel@sipsolutions.net> <CADsGw2Yy0O0rv0dxespJfcsnCXh-DnS4UY_1PX5M+fKHwqdhHQ@mail.gmail.com>
 <1506613923.8795.1.camel@sipsolutions.net>
From: Phani Siriki <yvsg.phanis@gmail.com>
Date: Thu, 28 Sep 2017 11:08:35 -0500
Message-ID: <CADsGw2aN5mvmHvg3jEiioYpvZMCFFNr0Qq7544Nj3rjQTjd+sQ@mail.gmail.com> (sfid-20170928_180840_003643_288573E5)
Subject: Re: Query on iw command to set txq params
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes Berg

I am trying to change the parameters for wireless mesh backbone
router. Is hostapd used for AP type configuration?

Best Regards
Phani

On Thu, Sep 28, 2017 at 10:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2017-09-28 at 10:40 -0500, Phani Siriki wrote:
>> Hi Johannes Berg
>>
>> Thank you for your reply.
>>
>> Could you please point me to any reference implementation I can check
>> to make the correct modification?
>
> Why don't you just set it in hostapd?
>
> johannes
