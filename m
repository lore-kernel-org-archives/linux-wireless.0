Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35643 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbbAaR5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 12:57:17 -0500
Received: by mail-ie0-f180.google.com with SMTP id rl12so9867601iec.11
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 09:57:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422725806.956.0.camel@egrumbacBox>
References: <CAAd0S9BwPQZhOZSzt2NU1SGjzv8i6685Y7Zb6qRQ1BzJ0P92SA@mail.gmail.com>
	<1422650111.1919.45.camel@sipsolutions.net>
	<CAAd0S9BRXoymMm=jSPptyYhywyAXVKyoTU_UJDyShDExX5ERRg@mail.gmail.com>
	<1422725806.956.0.camel@egrumbacBox>
Date: Sat, 31 Jan 2015 18:57:16 +0100
Message-ID: <CAAd0S9Ck7fNw2k=dPiNBFXxG9eqBzoA6a6yiPsoPq6GX2xK5dg@mail.gmail.com> (sfid-20150131_190132_778242_B4B30907)
Subject: Re: [IWLMVM] Firmware restart issue with 3.19-rc6-wl with AC 3160, REV=0x164
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 31, 2015 at 6:36 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
> On Sat, 2015-01-31 at 15:16 +0100, Christian Lamparter wrote:
>> > I guess Emmanuel will look at it on Sunday :)
>
> Or earlier.
>
>> Thanks! That did the trick!
>>
>
> what about this:
> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-next.git/commit/?id=c774905d98badddbeb4ad1bc653aedbd7ab024e4

Works.
