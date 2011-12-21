Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:52481 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LULOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 06:14:21 -0500
Received: by qadb15 with SMTP id b15so4636040qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 03:14:20 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAH5vBdK62juwC_qPPTfmgFkMp9XMy+3j1YLvBSxBc+zr9_oBJQ@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
	<1324424765.13074.281.camel@wwguy-huron>
	<CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
	<CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
	<CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
	<CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
	<CAH5vBdLq6zOagjmyM1h9Jon+fYnz5t05Dx7u6VqOWGHna+M3_Q@mail.gmail.com>
	<CA+icZUVixfk0h1ENU-tWMS5hgurbEV4jYpYNWbzaxCUx_b64UQ@mail.gmail.com>
	<CAH5vBdK62juwC_qPPTfmgFkMp9XMy+3j1YLvBSxBc+zr9_oBJQ@mail.gmail.com>
Date: Wed, 21 Dec 2011 12:14:20 +0100
Message-ID: <CA+icZUUhg91UAPMRGgXYAvo6wkr5ogb+vW8SsB28BeUP_6-g6w@mail.gmail.com> (sfid-20111221_121424_844728_21A9F95F)
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable when
 moving between multiple APs)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Cheng Renquan <crquan@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 11:36 AM, Cheng Renquan <crquan@gmail.com> wrote:
> On Wed, Dec 21, 2011 at 1:20 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
[...]
> read these from MAINTAINERS, just want to confirm if iwlwifi.git has more
> fresh content, this should be the most upstream, right?
>

Wey-Yi or Johannes can gave you precise answers on iwwifi development.
Of course the iwlwifi GIT (master) tree has latest stuff.
As you might have seen there are different GIT branches for stuff to
go into wireless-testing (experimental sofware), wireless-next
(linux-next.git) and wireless (linux.git).

> (only here has new fix and fixes are verified correct, then John Linville could
> pull from here the iwlwifi.git, right? As I understand, the MAINTAINERS model
> should be the way of iwlwifi.git => wireless.git => net.git => linus)
>

For mainline this workflow seems to be correct, but AFAICS you want an
official statement, so wait for Wey-Yi's answer :-).

> INTEL WIRELESS WIFI LINK (iwlwifi)
> M:      Wey-Yi Guy <wey-yi.w.guy@intel.com>
> M:      Intel Linux Wireless <ilw@linux.intel.com>
> L:      linux-wireless@vger.kernel.org
> W:      http://intellinuxwireless.org
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
> S:      Supported
> F:      drivers/net/wireless/iwlwifi/
>
>
> By comparing the two, I got that iwlwifi.git really has more, now
> prefetched for tomorrow
> when in office sometimes Internet is not available, and in case
> wireless.git with your patch
> still does not work, I could have a try of iwlwifi.git;
>

If you want latest iwlwifi bits, you can try also the work from there.
But a better strategy would be to test this order:
1. wireless (stable)
2. wireless-next or linux-next (testing)
3. wireless-testing and/or wiwlwifi (experimental)

- Sedat -

> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=history;f=drivers/net/wireless/iwlwifi
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless.git;a=history;f=drivers/net/wireless/iwlwifi
>
[...]
