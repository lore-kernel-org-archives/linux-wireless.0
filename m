Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33730 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755993AbcJLSgV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 14:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <1476295541.9670.26.camel@tiscali.nl>
References: <20161010071943.4717-1-chris@rorvick.com> <1476108164.5210.11.camel@coelho.fi>
 <1476180668.17022.21.camel@tiscali.nl> <1476252719.7776.6.camel@coelho.fi>
 <1476255135.1972.5.camel@tiscali.nl> <CAEUsAPYYJ3Gmh0T16veCn3wnzdD8bTxE+_U-AUYQpMo3TUd4Mg@mail.gmail.com>
 <1476295541.9670.26.camel@tiscali.nl>
From: Chris Rorvick <chris@rorvick.com>
Date: Wed, 12 Oct 2016 13:36:19 -0500
Message-ID: <CAEUsAPbuHQuM4qEuuOKButjPniQAaL11E8zJVV6No1WWTdUBKQ@mail.gmail.com> (sfid-20161012_203717_465955_BFD38B3C)
Subject: Re: [PATCH] iwlwifi: pcie: reduce "unsupported splx" to a warning
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Luca Coelho <luca@coelho.fi>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oren Givon <oren.givon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 12, 2016 at 1:05 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Wed, 2016-10-12 at 12:50 -0500, Chris Rorvick wrote:
>> This may already be apparent, but Dell sells two versions of the 9350:
>> one with the Broadcom adapter and one with the AC 8260.
>
> Off topic, for most readers: my version (with the AC 8260) came with
> Ubuntu preinstalled. Perhaps Chris' version came preinstalled with
> something else?

Exactly.  Mine came with Windows 10 and the Broadcom adapter, while
the "Developer Edition" comes preloaded with Ubuntu and has the AC
8260.  The Broadcom adapter has been supported since 4.4 but still
seems to have issues.  For example, I had it working at home but I was
not able to connect to a friend's AT&T U-Verse wireless gateway;
something was failing with -EBUSY.  I ordered the AC 8260 and it works
fine after the upgrade.

Chris
