Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:34234 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXKAEo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 00:44:58 -0400
Received: by py-out-1112.google.com with SMTP id u77so708303pyb
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 21:44:58 -0700 (PDT)
Message-ID: <43e72e890710312144w101efe6y198ff876bd201ca2@mail.gmail.com> (sfid-20071101_044501_564838_1F3BB9D9)
Date: Thu, 1 Nov 2007 00:44:57 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 0/7] ath5k: Few patches which start fixing G mode
Cc: linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <20071101044227.GI21987@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071101043157.GA21987@pogo> <20071101044227.GI21987@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/1/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Nov 01, 2007 at 12:31:57AM -0400, Luis R. Rodriguez wrote:
> > Here are a few patches which start fixing G mode settings.
>
> Forgot to mention these depend on Nick's 1-7 series patches plus,
>
> [PATCH] ath5k: Remove fill_tx_desc
> [PATCH] ath5k: 4word tx descriptor setup doesn't set BUF_LEN
>
> The last one by Ulrich Meis.
>
> I've also tested these patches on AR5211, AR5212, and on big-endian.

Crap.. I forgot to CC ath5k-devel.. well guys some patches on
linux-wireless for ath5k, hope you're subscribed. I'll be sure to send
them next time :T

  Luis
