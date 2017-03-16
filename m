Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35321 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdCPANO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 20:13:14 -0400
Received: by mail-lf0-f49.google.com with SMTP id j90so13657089lfk.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Mar 2017 17:13:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAA5faEQwWgkifyk_=aSr303yBQ-jGL=PZPQJz4u9+M20EDgKw@mail.gmail.com>
References: <CAAA5faEQwWgkifyk_=aSr303yBQ-jGL=PZPQJz4u9+M20EDgKw@mail.gmail.com>
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Wed, 15 Mar 2017 17:13:11 -0700
Message-ID: <CAAA5faEwapC5C2jGVteSa7K8OsQCTLui9=HSDZ5cWe2YrkfJTg@mail.gmail.com> (sfid-20170316_011318_183359_3692FBA0)
Subject: Re: accessing function send_addba_request
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looking at net/wireless.nl80211.c, no there isn't.

On Wed, Mar 15, 2017 at 2:53 PM, Reinoud Koornstra
<reinoudkoornstra@gmail.com> wrote:
> Hello Everyone,
>
> In kernel space I can easily call the function ieee_send_addba_request.
> Is there are way to call this function from userland by cfg80211 or nl80211?
> Thanks,
>
> Reinoud.
