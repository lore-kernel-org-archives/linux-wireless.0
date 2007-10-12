Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:51224 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXJLHWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 03:22:31 -0400
Received: by ug-out-1314.google.com with SMTP id z38so573825ugc
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 00:22:29 -0700 (PDT)
Message-ID: <4af2d03a0710120022o1aad59b1na6f92712fea4457@mail.gmail.com> (sfid-20071012_082236_222144_8553E601)
Date: Fri, 12 Oct 2007 09:22:29 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 0/4] ath5k: promiscuous bug, multicast and some docs
Cc: "John Linville" <linville@tuxdriver.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071011193918.GB4334@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071011193918.GB4334@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> This patch series adds a few things which have been sitting in my
> queue. Nick has better fixes for two of my previous patches so
> he'll be sending that. In this series I also added some new docs
> for some hw interrupts.

Hi,

please check your patches with scripts/checkpatch.pl, patch 2, 3, 4
and the followed fix doesn't comply with codingstyle.
