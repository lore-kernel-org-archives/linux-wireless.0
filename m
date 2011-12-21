Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49603 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1LUKhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 05:37:20 -0500
Received: by wgbdr13 with SMTP id dr13so14012169wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 02:37:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+icZUVixfk0h1ENU-tWMS5hgurbEV4jYpYNWbzaxCUx_b64UQ@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
 <1324424765.13074.281.camel@wwguy-huron> <CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
 <CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
 <CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
 <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
 <CAH5vBdLq6zOagjmyM1h9Jon+fYnz5t05Dx7u6VqOWGHna+M3_Q@mail.gmail.com> <CA+icZUVixfk0h1ENU-tWMS5hgurbEV4jYpYNWbzaxCUx_b64UQ@mail.gmail.com>
From: Cheng Renquan <crquan@gmail.com>
Date: Wed, 21 Dec 2011 02:36:58 -0800
Message-ID: <CAH5vBdK62juwC_qPPTfmgFkMp9XMy+3j1YLvBSxBc+zr9_oBJQ@mail.gmail.com> (sfid-20111221_113724_621616_E6A8C567)
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable when
 moving between multiple APs)
To: sedat.dilek@gmail.com
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 1:20 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> You read the URL I gave you?
>
> "...unfortunately, this -rc6 is missing some important iwlwifi fixes.
> These were included in wireless.git#master (master-2011-12-14).

Sorry, I didn't notice that sentence, just saw a single patch but I
usually prefer checking out from a git tree,

read these from MAINTAINERS, just want to confirm if iwlwifi.git has more
fresh content, this should be the most upstream, right?

(only here has new fix and fixes are verified correct, then John Linville could
pull from here the iwlwifi.git, right? As I understand, the MAINTAINERS model
should be the way of iwlwifi.git => wireless.git => net.git => linus)

INTEL WIRELESS WIFI LINK (iwlwifi)
M:      Wey-Yi Guy <wey-yi.w.guy@intel.com>
M:      Intel Linux Wireless <ilw@linux.intel.com>
L:      linux-wireless@vger.kernel.org
W:      http://intellinuxwireless.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
S:      Supported
F:      drivers/net/wireless/iwlwifi/


By comparing the two, I got that iwlwifi.git really has more, now
prefetched for tomorrow
when in office sometimes Internet is not available, and in case
wireless.git with your patch
still does not work, I could have a try of iwlwifi.git;

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=history;f=drivers/net/wireless/iwlwifi
http://git.kernel.org/?p=linux/kernel/git/linville/wireless.git;a=history;f=drivers/net/wireless/iwlwifi

>
> I have attached a single "wireless" patch to make affected people happy...."
>
> Is John Linville (Linux Maintainer of the wireless sub-tree)
> wireless.git not official enough for you?
> Just FYI, this is the tree which is regularly pulled into net.git and
> from there to Linus-tree (mainline, currently 3.2-rcX).
> Though...

Thank you, acknowledged,
