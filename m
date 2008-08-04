Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:43310 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYHDSH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 14:07:26 -0400
Received: by wr-out-0506.google.com with SMTP id 69so1568609wri.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 11:07:25 -0700 (PDT)
Message-ID: <43e72e890808041107y2c3c75fsef049eb09a4c52b7@mail.gmail.com> (sfid-20080804_200728_862940_4D503F1E)
Date: Mon, 4 Aug 2008 11:07:24 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: ath9k and signal level
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080730024035.GA2976@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080730024035.GA2976@bromo.msbb.uc.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 7:40 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>    I was finally able to get the ath9k drivers to work
> under 2.6.26-rc1 by using the previous ath9k git patch,
> the 16 new ath9k patches, the Berg's proposed skb->cb
> patch and the following patch I constructed for ath9k
> to mimic the skb->cb changes...

Thanks for the suggested patch. I've integrated a modified version of it.

> So far the ath9k driver seems to be working well with one oddity.
> I find that the gnome menu applet (using the NetworkManager in Fedora 9)
> shows a signal level of zero (even though it recognizes that the connection
> exists to the wireless network). Is this a known issue?

Yes and I've recently added initial patch to add link quality support.

> ps Are all 16 patches now applied to the ath9k git?

Yes, and more.

  Luis
