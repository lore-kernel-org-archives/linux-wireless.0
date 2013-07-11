Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54042 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3GKHec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 03:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Vf0BO_d=qPrpU=mYAv6DeRPanQqV6BshkVjJ0Tf4ponw@mail.gmail.com>
References: <CAB=NE6W6oa1Oa9O_s7B_4qKHdEz6S3DhVyvtpzP78XqRM_xk8A@mail.gmail.com>
 <CAB=NE6Vf0BO_d=qPrpU=mYAv6DeRPanQqV6BshkVjJ0Tf4ponw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 11 Jul 2013 00:34:10 -0700
Message-ID: <CAB=NE6Xv91ma2KyXkEUUjFwH7nk4vdXfX8A6i9KmvUvYKn_tgg@mail.gmail.com> (sfid-20130711_093435_500425_350F69CF)
Subject: Re: backports based on next-20130618
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 1, 2013 at 2:39 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Mon, Jul 1, 2013 at 2:25 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> A new backports release has been made based on next-20130618, this has
>> the new upstream alx driver, and the ath10k driver.
>>
>> https://www.kernel.org/pub/linux/kernel/projects/backports/2013/06/18/backports-20130618.tar.bz2
>
> Sorry it just has alx, ath10k requires a small patch that I think
> someone has sitting somewhere, next release.

Nevermind, it was in already and in fact compiled fine as part of this release.

  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/mac.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/debug.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/core.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/htc.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/htt.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/htt_rx.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/htt_tx.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/txrx.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/wmi.o
  CC [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/bmi.o
  LD [M]  /home/mcgrof/tmp/poo/backports-20130618/drivers/net/wireless/ath/ath10k/ath10k_core.o

 Luis
