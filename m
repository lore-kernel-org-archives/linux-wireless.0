Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:44372 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdINThE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:37:04 -0400
Received: by mail-io0-f176.google.com with SMTP id v36so3266162ioi.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 12:37:04 -0700 (PDT)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
 <1505414172.31630.13.camel@sipsolutions.net>
 <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com>
 <1505416964.31630.17.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <7210eb81-be88-8554-deb8-1926606ef64b@gmail.com> (sfid-20170914_213707_535616_4F94187D)
Date: Thu, 14 Sep 2017 14:37:02 -0500
MIME-Version: 1.0
In-Reply-To: <1505416964.31630.17.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> My earlier point is that software roams need to have the exact same
>> behavior as well.  And my understanding is that when we try to
>> Fast-Transition (e.g. issue a CMD_ASSOCIATE), operstate is no longer
>> UP.
> 
> I'm not sure - I don't know what the state machine in wpa_s goes
> through here. Probably easier to test than try to reason about the
> code...

I'm talking about the kernel behavior, not wpa_s.  My guys discovered 
that the kernel seems to twiddle operstate automagically?  E.g. see 
description of 
https://git.kernel.org/pub/scm/network/wireless/iwd.git/commit/?id=4d20db05d7c8806749db574e9231bd5d1c476c7f

Regards,
-Denis
