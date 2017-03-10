Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35448 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933374AbdCJPYr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 10:24:47 -0500
Received: by mail-qk0-f177.google.com with SMTP id v125so168602160qkh.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 07:24:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zigt5xui.fsf@purkki.adurom.net>
References: <58B09082.7020704@cococorp.com> <1488202227.28431.9.camel@sipsolutions.net>
 <58B487A8.7000602@cococorp.com> <1488443814.8390.3.camel@sipsolutions.net>
 <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com> <1488803913.5761.11.camel@sipsolutions.net>
 <19214832-030e-2028-49a2-2db087c8c857@neratec.com> <87zigt5xui.fsf@purkki.adurom.net>
From: Alexis Green <agreen@uniumwifi.com>
Date: Fri, 10 Mar 2017 07:24:45 -0800
Message-ID: <CAAnMG+M_pU64K+KUMgcwPu65ZeHQ6qxOXGt=Q8L0K7_nGEf=Ng@mail.gmail.com> (sfid-20170310_162450_976477_D6ECF2D5)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Matthias May <matthias.may@neratec.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jesse Jones <jjones@uniumwifi.com>,
        Alexis Green <agreen@cococorp.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These images work intermittently for me. Here they are rehosted:

[1] http://i.imgur.com/zM0eLNk.png
[2] http://i.imgur.com/E7GL7U3.png

On Fri, Mar 10, 2017 at 12:40 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Matthias May <matthias.may@neratec.com> writes:
>
>> [1] http://may.nu/images/problem.png
>> [2] http://may.nu/images/jittered.png
>
> I get 404 "Not Found" for these.
>
> --
> Kalle Valo
