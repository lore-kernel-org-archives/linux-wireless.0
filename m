Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54642 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbeC0UvO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 16:51:14 -0400
Received: by mail-wm0-f68.google.com with SMTP id h76so1151662wme.4
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2018 13:51:13 -0700 (PDT)
Subject: Re: [PATCH v7 00/11] EAPoL over NL80211
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
References: <20180326175251.20666-1-denkenz@gmail.com>
 <5AB9FACF.4060006@broadcom.com>
 <00fa528f-5c5e-1263-b058-317de71ee769@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ABAAEBF.6080900@broadcom.com> (sfid-20180327_225131_736733_66C866EE)
Date: Tue, 27 Mar 2018 22:51:11 +0200
MIME-Version: 1.0
In-Reply-To: <00fa528f-5c5e-1263-b058-317de71ee769@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/27/2018 4:42 PM, Denis Kenzior wrote:
> Hi Arend,
>
> On 03/27/2018 03:03 AM, Arend van Spriel wrote:
>> On 3/26/2018 7:52 PM, Denis Kenzior wrote:
>>> The proposed patchset has been tested in a mac80211_hwsim based
>>> environment with
>>> hostapd and iwd.
>>
>> Hi Denis,
>>
>> Looking pretty good. Do you also have hostapd and iwd patches
>> available somewhere. I would like to see if I can get brcmfmac using it.
>>
>
> There are some very raw iwd patches I have.  They're sitting in my
> private tree.  I can send these to you privately or maybe setup a wiki
> page somewhere for you to grab them.  They do not take the
> NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211 feature bit into account,
> so I still need to work on these.  Was holding off until Johannes merges
> at least the high level API bits.

If they are not fit for posting feel free to send them to me.

> I never modified hostapd.  iwd has a very rudimentary AP mode support.
> Not fully useable but enough to run a 4-way handshake.  So with that in
> mind I concentrated on two scenarios while testing:
>
> 1. modified iwd (STA) utiling EAPoL over NL80211 connecting to stock
> hostapd.  In effect this was testing both the legacy and the new behavior.
>
> 2. modified iwd (STA) utilizing EAPoL over NL80211 connecting to stock
> hostapd.  Then disconnecting and connecting to modified iwd (AP).
>
> iwd doesn't (yet) have support for P2P, IBSS or Mesh.  So the bits
> touching these features should be considered untested.

That's fine. Just wanted to get a feel about the feature. May provide 
some lessons to try it with a non-mac80211 driver and I wanted to have a 
spin with iwd as that is new to me.

Regards,
Arend
