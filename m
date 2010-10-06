Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44227 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab0JFOZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 10:25:58 -0400
Received: by iwn5 with SMTP id 5so9812623iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 07:25:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101006132301.GA2472@tuxdriver.com>
References: <AANLkTin9hFUE_RH0Zb4OuV2dU_kJs6_ap=VxEmT3e3F8@mail.gmail.com> <20101006132301.GA2472@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 6 Oct 2010 07:25:36 -0700
Message-ID: <AANLkTi=1-r8XZHn9nqbbh2N=7yrsKXZbgxHNcNg+qFxo@mail.gmail.com>
Subject: Re: Why were patches reverted on 2010-09-21? (carl9170 and others)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Christian Jaeger <chrjae@gmail.com>,
	linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 6, 2010 at 6:23 AM, John W. Linville <linville@tuxdriver.com> wrote:
> I swear, I should just stop doing wireless-testing at all...
>
> Let me explain...again...
>
> The history in wireless-testing is dirty.  It contains crap like
> these reverts only so that I can continue to pull cleanly from
> wireless-next-2.6 and wireless-2.6 even after I have had to rebase
> them.  Otherwise, I would have to do lots of pointless fixups in a
> tree that will never be pulled by Linus anyway.  The ugly history is
> the alternative to rebasing, so that those who pull can do so without
> git complaining.
>
> The point of wireless-testing is to provide something between linux-2.6
> and linux-next, something that is close to the stabilising release but
> with currently pending wireless patches.  It is not intended to be
> a basis for historical research.  Don't use it for that.

Since we get these questions quite often I've taken what you have
written and merged it here:

http://wireless.kernel.org/en/developers/process#wireless-testing.git

  Luis
