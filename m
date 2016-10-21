Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36636 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754986AbcJUS7i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 14:59:38 -0400
Received: by mail-wm0-f45.google.com with SMTP id b80so1200200wme.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 11:59:37 -0700 (PDT)
Subject: Re: [PATCH 2/2] mac80211: use inline kernel-doc for struct
 ieee80211_hw
To: Johannes Berg <johannes@sipsolutions.net>,
        Jani Nikula <jani.nikula@intel.com>,
        linux-wireless@vger.kernel.org
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
 <1477054644-5945-2-git-send-email-jani.nikula@intel.com>
 <1477054892.4068.44.camel@sipsolutions.net>
Cc: linux-doc@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a6fb17b3-0ec6-e23b-4ae3-f84385cf84ae@broadcom.com> (sfid-20161021_205950_578765_54357DB5)
Date: Fri, 21 Oct 2016 20:59:35 +0200
MIME-Version: 1.0
In-Reply-To: <1477054892.4068.44.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-10-16 15:01, Johannes Berg wrote:
> On Fri, 2016-10-21 at 15:57 +0300, Jani Nikula wrote:
>> It's easier to manage the kernel-doc for the fields when they
>> documentation is next to the field.
> 
> Hah, I wasn't even aware this was possible. Thanks!

Me neither. I actually found it annoying to have all kernel-doc above
the type definition and indeed easy to miss fields. Now struct
ieee80211_hw is not alone and we have it all over the place in the
wireless subsystem. Is this something we want to embrace and maybe find
janitors/newbies/coccinelle-gurus to address it. Not sure if coccinelle
could deal with this.

Regards,
Arend
