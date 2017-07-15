Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38682 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751182AbdGOU67 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Jul 2017 16:58:59 -0400
Message-ID: <1500152336.22048.188.camel@coelho.fi> (sfid-20170715_225903_311795_94723C0A)
From: Luca Coelho <luca@coelho.fi>
To: David Goodenough <dfgoodenough@googlemail.com>,
        linux-wireless@vger.kernel.org
Date: Sat, 15 Jul 2017 23:58:56 +0300
In-Reply-To: <34104523.kB8OiK1t1Y@stargate>
References: <34104523.kB8OiK1t1Y@stargate>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Intel 8265/8275 microcode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-07-15 at 10:03 +0100, David Goodenough wrote:
> I have a laptop which reports the wifi adapter to be an 8265/8275 rev 78 
> and the driver complains that it can not find:-
> 
> iwlwifi-8265-23.ucode
> iwlwifi-8265-24.ucode
> iwlwifi-8265-25.ucode
> iwlwifi-8265-26.ucode
> iwlwifi-8265-27.ucode
> iwlwifi-8265-28.ucode
> 
> and they not appear to be in the kernel.org github.  Where do I find
> them and could they be added to github?

Does your wifi card work? The driver tries to find one of the supported
versions, starting from highest and going down to the lowest.  It seems
that you have -22.ucode and, if that's the case, everything should be
fine and you can ignore these messages.

It is an old known problem that there is no way to try to load a
firmware without getting an error message.  People are working on
solving this, but until then, just ignore this messages and everything
should be fine. :)

--
Cheers,
Luca.
