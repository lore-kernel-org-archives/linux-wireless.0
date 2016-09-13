Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:32885 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759017AbcIMPFu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 11:05:50 -0400
Received: by mail-oi0-f49.google.com with SMTP id y2so386755338oie.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2016 08:05:50 -0700 (PDT)
Subject: Re: Support of rtl8723bs
To: Hanno Zulla <abos@hanno.de>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Bastien Nocera <hadess@hadess.net>
References: <688574b6-1141-f408-d397-535f1f69999e@hanno.de>
 <1473683031.2930.3.camel@hadess.net> <wrfjtwdli39u.fsf@redhat.com>
 <5b920339-abcd-0fc4-f054-039155c531a0@lwfinger.net>
 <cd991918-0bfa-a9a3-15e5-aa8561db2c65@hanno.de>
 <1473695458.6389.3.camel@hadess.net> <wrfj4m5lhzja.fsf@redhat.com>
 <4efa3f1a-a91c-7b19-43e3-508cbbd4676e@hanno.de>
Cc: anthony.wong@canonical.com, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a9235772-ab37-255c-2fb3-ce2ed1104ad5@lwfinger.net> (sfid-20160913_170607_770187_E6AB3A6E)
Date: Tue, 13 Sep 2016 10:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <4efa3f1a-a91c-7b19-43e3-508cbbd4676e@hanno.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2016 02:47 AM, Hanno Zulla wrote:
> Hi,
>
>> The issues I am aware of is to start out changing the register access
>> macros into function pointers and stick them all into the fileops
>> structure. Provide a set of SDIO ones to match the USB ones. Then you
>> will need some code to detect the device, as that part will obviously be
>> different from the USB device detection.
>>
>> I know there are a few issues to look out for in the hw register init
>> files to look out for too, that does some special casing for SDIO, but
>> that should be limited. I am happy to point someone in the right
>> direction on that when they get to that.
>
> I had a brief look into the sources of other drivers implementing SDIO,
> but not being a kernel-dev, this is out of my league.
>
> If you decide to reprioritize your TODO-List in favour of adding SDIO
> sooner, I'll be gladly testing this for you on my hardware (and buy you
> a beer).

I received a CherryTrail z8300 device yesterday with RTL8723BS wifi and BT. I 
have started making the changes that Jes suggested. Once I get something 
running, I will post patches here for review, and I will also make them 
available in Bastien's repo.

I make no promises on when anything will be available.

Larry
