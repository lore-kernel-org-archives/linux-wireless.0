Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33354 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932217AbcJUHuZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 03:50:25 -0400
Received: by mail-pf0-f174.google.com with SMTP id 128so52781829pfz.0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 00:50:25 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: allow vendor commands to be sent to nan
 interface
To: Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luca@coelho.fi>
References: <20161019044747.15921-1-luca@coelho.fi>
 <e7d135c6-e114-ffa5-a52f-3ee85c18641e@broadcom.com>
 <1476967356.4929.20.camel@sipsolutions.net>
 <2fb83452-e4c2-f08c-c21b-b51c17401a3b@broadcom.com>
 <1476967536.4929.23.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0b3289e0-3d1f-66ba-fd84-1629bb8ab01b@broadcom.com> (sfid-20161021_095050_493908_E2108F98)
Date: Fri, 21 Oct 2016 09:50:20 +0200
MIME-Version: 1.0
In-Reply-To: <1476967536.4929.23.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 20-10-2016 14:45, Johannes Berg wrote:
> On Thu, 2016-10-20 at 14:44 +0200, Arend Van Spriel wrote:
>>  
>> Sure. On top of this patch or will you deal with those conflicts?
>>
> 
> I already applied this, so on top please (i.e. just resend what you
> just had, with a commit message?)

Yup. Did not check/realize/whatever. I send it out yesterday [1].

Regards,
Arend

[1] https://patchwork.kernel.org/patch/9387467/
