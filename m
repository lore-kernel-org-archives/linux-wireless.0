Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:42487 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbXJLOKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 10:10:06 -0400
Received: by wr-out-0506.google.com with SMTP id 36so533170wra
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 07:10:05 -0700 (PDT)
Message-ID: <43e72e890710120710s77001179x9700ac77712cfe2d@mail.gmail.com> (sfid-20071012_151011_669837_257A2A63)
Date: Fri, 12 Oct 2007 10:10:04 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 0/4] ath5k: promiscuous bug, multicast and some docs
Cc: "John Linville" <linville@tuxdriver.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4af2d03a0710120022o1aad59b1na6f92712fea4457@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071011193918.GB4334@pogo>
	 <4af2d03a0710120022o1aad59b1na6f92712fea4457@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 10/11/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > This patch series adds a few things which have been sitting in my
> > queue. Nick has better fixes for two of my previous patches so
> > he'll be sending that. In this series I also added some new docs
> > for some hw interrupts.
>
> Hi,
>
> please check your patches with scripts/checkpatch.pl, patch 2, 3, 4
> and the followed fix doesn't comply with codingstyle.

Those pesky leading spaces.. thanks, I'll resend and add the new patch
to it with Nick's new comments on IRQs as well.

  Luis
