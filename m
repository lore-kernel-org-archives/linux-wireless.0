Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:52795 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdI1Pkh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Sep 2017 11:40:37 -0400
Received: by mail-qk0-f181.google.com with SMTP id o77so1810496qke.9
        for <linux-wireless@vger.kernel.org>; Thu, 28 Sep 2017 08:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1506613011.8795.0.camel@sipsolutions.net>
References: <CADsGw2Zax=r7QBGYPO+bs0BTmb+JUVZ-Y-X+_gfRrKj8tQy27Q@mail.gmail.com>
 <1506613011.8795.0.camel@sipsolutions.net>
From: Phani Siriki <yvsg.phanis@gmail.com>
Date: Thu, 28 Sep 2017 10:40:35 -0500
Message-ID: <CADsGw2Yy0O0rv0dxespJfcsnCXh-DnS4UY_1PX5M+fKHwqdhHQ@mail.gmail.com> (sfid-20170928_174040_372699_F07AFE96)
Subject: Re: Query on iw command to set txq params
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes Berg

Thank you for your reply.

Could you please point me to any reference implementation I can check
to make the correct modification?

Best Regards
Phani

On Thu, Sep 28, 2017 at 10:36 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2017-09-21 at 13:01 -0500, Phani Siriki wrote:
>> Hi All
>>
>> I am trying to apply the path mentioned below to set txq params using
>> iw command.
>>
>> http://www.spinics.net/lists/linux-wireless/msg42585.html
>
> The patch is wrong (now?), it needs to use the *netdev* not just the
> wiphy.
>
> johannes
