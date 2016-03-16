Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35005 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbcCPVXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 17:23:30 -0400
Received: by mail-io0-f171.google.com with SMTP id g203so75604747iof.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 14:23:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA7A541@hasmsx107.ger.corp.intel.com>
References: <CA+55aFxOMO6u6xu4Pz7BzbLD=SwwzdPcSU2dX2S0kkh4jFaVbw@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32EA7A541@hasmsx107.ger.corp.intel.com>
Date: Wed, 16 Mar 2016 14:23:29 -0700
Message-ID: <CA+55aFw8_rtr8v65LYXYJpWq40TyTPpt9hdBzwr8-VYpaKMdRQ@mail.gmail.com> (sfid-20160316_222334_361855_7E8BCFBC)
Subject: Re: iwlwifi incomplete initialization in Linux 4.5?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	WCS WCD Linux SW Group Staff
	<wcs.wcd.linux.sw.group.staff@intel.com>,
	"Barash, Yair" <yair.barash@intel.com>,
	"Amir, Ido" <ido.amir@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2016 at 2:13 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>
> This ... typically means that the firmware got stuck while sending
> packets. Can you tell me on what band your router operates? 2.4GHz or
> 5.2GHz?

Both.

> Do you use 20Mhz or 40MHz?

HT20 on 2.4GHz, HT40 on 5GHz.

At least that's the wireless AP setup.

> Basically, I'd like to see the output of iw dev

I'll have to walk over and check. I don't have my machines set up so
you can get into them over the network..

> Hmm, this is strange since 4.4 and 4.5 will both load -16.ucode which
> you seemed to be running when the have the Queue hang message.

Correct. Both cases used the 16 ucode, since that's what F22 comes
with. I upgrade the kernel, but intentionally don't touch anything
else in the system.

               Linus
