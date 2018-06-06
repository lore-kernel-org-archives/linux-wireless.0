Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35555 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752124AbeFFTI3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 15:08:29 -0400
Received: by mail-wm0-f44.google.com with SMTP id j15-v6so14133085wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2018 12:08:28 -0700 (PDT)
Subject: Re: How to let devcoredump know data has been read?
To: Brian Norris <briannorris@chromium.org>,
        Ben Greear <greearb@candelatech.com>
References: <6f54d11c-74a5-568a-ba1e-3f37edb28384@candelatech.com>
 <20180605225324.GA195207@rodete-desktop-imager.corp.google.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B18312B.9020208@broadcom.com> (sfid-20180606_210833_142023_7D246AA6)
Date: Wed, 6 Jun 2018 21:08:27 +0200
MIME-Version: 1.0
In-Reply-To: <20180605225324.GA195207@rodete-desktop-imager.corp.google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/6/2018 12:53 AM, Brian Norris wrote:
> Unfortunately, devcoredump is a bit lacking in documentation. Arend was
> writing a bit for the new trigger mechanism at least.

I did indeed write ABI doc for user-space trigger mechanism and you 
brought up the need to have ABI doc for devcoredump. I agree it would be 
useful and it is dangling at the bottom of my todo list so I did not get 
to it (yet). Hopefully I can spend a moment on it.

Regards,
Arend
