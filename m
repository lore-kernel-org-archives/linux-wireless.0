Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:46104 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbaICTPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:15:20 -0400
Received: by mail-ig0-f182.google.com with SMTP id a13so9685263igq.15
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:15:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21511.8546.157916.710879@gargle.gargle.HOWL>
References: <CAOHJ0jTHtVvJ43y7m-=UqHeMJfNiMYU2Peg9buxXU+wBigwu5g@mail.gmail.com>
 <CA+BoTQm+x0kD9m3vVv98MwYOXjfgO1noXOnzdbk5o41S+DLewQ@mail.gmail.com>
 <CAOHJ0jSoSd97vFEMgxC3cC8AnaEGdwbUiBBoeM7UfLJcha0Ujg@mail.gmail.com>
 <CA+BoTQnCoZL=GzUh4vJqOQ=-PZ1BwZcUO21spUPB5KF1fUSiRw@mail.gmail.com> <21511.8546.157916.710879@gargle.gargle.HOWL>
From: Robb <rbarr138@gmail.com>
Date: Wed, 3 Sep 2014 14:14:59 -0500
Message-ID: <CAOHJ0jRhDN9n56BnyCwgSxdeKhDRYzg6ua9Z_N+pBOTRF20KpQ@mail.gmail.com> (sfid-20140903_211554_309976_727ACCF7)
Subject: Re: Cannot get ACS to work with hostapd-2.2 "Unknown event 49"
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Sujith Manoharan <sujith@msujith.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You are correct, the HW MAC for the chips supported by ath9k_htc is mostly the
> same as the ones supported by ath9k. But, driver support for survey dump
> is lacking.

Just to be clear, is it the driver or the firmware that does not support
the survey dump?

> ath9k_htc doesn't provide survey dump data for any USB card.

Again, is this attributed to ath9k_htc devices physically not having
the ability,
or do you know if it is just that no one has written the code as of yet?

I am trying to determine if it can be done and if so, whether to start in
driver or firmware?

Thanks.
