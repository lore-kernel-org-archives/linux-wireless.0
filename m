Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36336 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754911AbdJQNNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 09:13:46 -0400
Message-ID: <1508246019.10607.77.camel@sipsolutions.net> (sfid-20171017_151404_600872_6ACD1A03)
Subject: Re: Commit 0711d638 breaks mwifiex
From: Johannes Berg <johannes@sipsolutions.net>
To: Jesse Sung <jesse.sung@canonical.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org
Date: Tue, 17 Oct 2017 15:13:39 +0200
In-Reply-To: <CAH10aOjmMdN2pGP8FDwZQ6BRcu2O5PiGjk+kKb6bAa7nS=ap8g@mail.gmail.com>
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
         <1508233890.10607.70.camel@sipsolutions.net>
         <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
         <1508237298.10607.76.camel@sipsolutions.net>
         <CAH10aOjmMdN2pGP8FDwZQ6BRcu2O5PiGjk+kKb6bAa7nS=ap8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-17 at 21:07 +0800, Jesse Sung wrote:
> 
> > Not really quite sure about it yet, but that should address the
> > issue?
> 
> A very rough test by issuing reassociate in wpa_cli:
> mwifiex works after reassociate - looks good

Ok. Discussing this with Ilan, we realized that this was buggy, and
came up with this patch instead:

https://p.sipsolutions.net/8f9d5917a5cbe4b3.txt

Can you also give that a spin?

johannes
