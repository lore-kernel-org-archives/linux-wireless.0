Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59909 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaLRPNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 10:13:33 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20141217155951.GA3144@tuxdriver.com>
References: <20141217155951.GA3144@tuxdriver.com>
Date: Thu, 18 Dec 2014 16:13:31 +0100
Message-ID: <CA+icZUWsv4ZR1LN09=r-g525Wyreo1HNNzUKgXnq6cSt6QXcqw@mail.gmail.com> (sfid-20141218_161337_440013_E99F4ED6)
Subject: Re: changes to Linux wireless maintenance
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org, linux-nfc@ml01.01.org,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>, lwn@lwn.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2014 at 4:59 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Greetings,
>
> Almost 9 years ago, Jeff Garzik wrote a message on LKML detailing
> the sad state of wireless LANs in the Linux world.  The point of his
> message was "So... there it is.  We suck.  There's hope.  No Luke
> Skywalker in sight.":
>
>         https://lkml.org/lkml/2006/1/5/671
>
> Shortly thereafter, I became the maintainer for wireless LANs in the
> Linux kernel:
>
>         https://lkml.org/lkml/2006/1/18/377
>
...

Hmm, I remember testing the eraly iwlwifi stuff because I wanted that
damn bith running on my HP nc6400 notebook these days (iwl3945).

Following the wireless ML made a real fun for me and I will allways
associate "linux-wireless" with "John W. Linville".
So life is change, I had some hurtful/wretched experiences the last two years.
Anyway, thanks and my best wishes with any other projects :-).

> The mac80211, bluetooth, and nfc trees have fed through me for some
> time.  I am now asking these trees to send pull request directly to
> David Miller.  Since these trees are managed through git, my hope is
> that they will not place any significant burden on Dave.
>
> As for the wireless driver patches, I have asked Kalle Valo
> to handle patch review and merge duties for everything under the
> drivers/net/wireless directory.  This will now include not only the ath
> patches he already manages, but other drivers that don't have trees
> such as mwifiex, rt2x00, rtlwifi, and others.  For consistency, the
> iwlwifi tree will also be merged through Kalle's new tree.  I expect
> that Kalle will announce any relevant details in a follow-up message.
>

Hmm, not sure why mac80211 stuff should not go via wireless trees?
If I remember testing early wireless stuff I pulled this order...

mac80211 -> wireless -> net (Git trees)

Can you explain why mac80211 separate from wireless stuff?

- Sedat -
