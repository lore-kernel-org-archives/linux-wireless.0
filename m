Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42569 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUJHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 04:07:16 -0500
Received: by werm1 with SMTP id m1so2532217wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 01:07:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
 <1324424765.13074.281.camel@wwguy-huron> <CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
 <CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
 <CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com> <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
From: Cheng Renquan <crquan@gmail.com>
Date: Wed, 21 Dec 2011 01:06:54 -0800
Message-ID: <CAH5vBdLq6zOagjmyM1h9Jon+fYnz5t05Dx7u6VqOWGHna+M3_Q@mail.gmail.com> (sfid-20111221_100722_264618_80B7F9FF)
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable when
 moving between multiple APs)
To: sedat.dilek@gmail.com
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 12:53 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> /me confused...
> Your subject is/was " ...linux 3.2-rcX iwlwifi driver's problem...",
> now you are talking about iwlwifi.git.
> Not sure what's the base of iwlwifi.git, but I guess it is wireless-testing?
> BTW; what do you meant by 3.2-rcX, what is X? -rc1, -rc2...-rc6?
> Which of those -rcX are affected?

More details are tracked into the bug, the kernel version one between
linus offical 3.2.0-rc5 and 3.2.0-rc6,
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2338

This kernel has been running on my Lenovo laptop more than 1 week with
no reboot (only suspend & resume),
and wifi roaming problems happened in office everyday,

[root@archtop ~]# modinfo iwlwifi
filename:      /lib/modules/3.2.0-rc5+/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko

>>> [1] http://lkml.org/lkml/2011/12/17/14
>>
>> Is it already in iwlwifi.git? I'm gonna test it when I'm in office,
>> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git

Now I'm asking if the patch mentioned in your above link is already in
iwl git tree,
since it's Intel's offical tree for iwlwifi, I'm gonna clone a latest
tree and test it;

But you're using a googlemail, now I'm not sure if you're working in
that Intel iwl team...
