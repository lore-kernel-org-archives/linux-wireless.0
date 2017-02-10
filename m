Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:58047 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750979AbdBJHhM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 02:37:12 -0500
Message-ID: <1486712222.2192.3.camel@perches.com> (sfid-20170210_083753_171786_0B272397)
Subject: Re: [PATCH 1/3] ath10k: remove ath10k_vif_to_arvif()
From: Joe Perches <joe@perches.com>
To: Adrian Chadd <adrian@freebsd.org>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amadeusz =?UTF-8?Q?S=C5=82awi=C5=84ski?=
        <amadeusz.slawinski@tieto.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 09 Feb 2017 23:37:02 -0800
In-Reply-To: <CAJ-Vmom7k3Tsgs8tRHQppmL7XxADS3V24AGOQY5QgkrSgr5Qzg@mail.gmail.com>
References: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com>
         <CAJ-VmonrHpS3MArM9ohHgLvb6xspP_gnVVeJWA9F-pjUpJ+LZA@mail.gmail.com>
         <87y3xi4b28.fsf@qca.qualcomm.com> <5899DDD7.7000605@candelatech.com>
         <87tw82il32.fsf@kamboji.qca.qualcomm.com>
         <CAJ-Vmom7k3Tsgs8tRHQppmL7XxADS3V24AGOQY5QgkrSgr5Qzg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-02-09 at 23:14 -0800, Adrian Chadd wrote:

> If there
> were accessors for the skb data / len fields (like we do for mbufs)
> then porting the code would've involved about 5,000 less changed
> lines.

What generic mechanisms would you suggest to make
porting easier between bsd and linux and what in
your opinion are the best naming schemes to make
these functions easiest to read and implement
without resorting to excessive identifier lengths?

If you have some, please provide examples.
