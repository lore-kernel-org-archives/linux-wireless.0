Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58998 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965442AbdEXH5c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 03:57:32 -0400
Message-ID: <1495612648.24885.62.camel@coelho.fi> (sfid-20170524_095811_709208_A6C130D5)
From: Luca Coelho <luca@coelho.fi>
To: sedat.dilek@gmail.com, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Date: Wed, 24 May 2017 10:57:28 +0300
In-Reply-To: <CA+icZUU3TwPOnABirE+0kT1tjr=fWLXPJFeCprsCSvXmqiiC+A@mail.gmail.com>
References: <CA+icZUU3TwPOnABirE+0kT1tjr=fWLXPJFeCprsCSvXmqiiC+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [Linux-4.9.28] iwlwifi 6230 AGN: Microcode SW error detected
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-24 at 09:41 +0200, Sedat Dilek wrote:
> Hi,

Hi Sedat,


> I am seeing the below/following in my logs today.
> My AP is a Lenovo Moto-Z with LTE support.
> 
> Can you comment on this?
> Is this a "buggy" firmware and a new firmware around?

Looks like a buggy firmware, but unfortunately we don't have a newer
firmware with a fix for this.


> My kernel-config and full dmesg are attached.
> 
> If you need further informations, please let me know.
> 
> Hope this helps.
> 
> Regards,
> - Sedat -
> 
> P.S.: Excerpts from my dmesg-log.
> 
> [   16.708016] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R)
> Advanced-N 6230 AGN, REV=0xB0

This is a really old NIC (6+ years old) and unfortunately we can't
provide firmware fixes for it anymore.

Hopefully the recovery flow in the driver recovers the connectivity and
everything continues working fine.


--
Cheers,
Luca.
