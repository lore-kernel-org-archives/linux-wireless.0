Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38399 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbJNJF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 05:05:27 -0400
Received: by wieq12 with SMTP id q12so72223967wie.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 02:05:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444809642.3054.6.camel@sipsolutions.net>
References: <1444635356-19975-1-git-send-email-ola1olsson@gmail.com>
	<1444727650.1961.10.camel@sipsolutions.net>
	<CABAco3CLCtFOofHMbJSz-Okcc4BM4nnVwO5By8DeZUYJrsCt6Q@mail.gmail.com>
	<1444805527.3054.4.camel@sipsolutions.net>
	<CABAco3BpY-hU=9MGzovyUfyRgXMynikNbUD3cScievczq2qsKg@mail.gmail.com>
	<1444809642.3054.6.camel@sipsolutions.net>
Date: Wed, 14 Oct 2015 11:05:26 +0200
Message-ID: <CABAco3B1OJ4da4+7mg=3ZxkS=6JpNFQJ45uVmBJm=-MS+TgAKA@mail.gmail.com> (sfid-20151014_110547_836303_9F926DEB)
Subject: Re: [PATCH] ocb: use correct "MHz" instead of "MHZ"
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yeah, ouch, I don't really want that. Perhaps you can add -Wno-unused
> -parameters to your Android makefile.

Worked like a charm (though I had to remove 's' in parameters). Thanks!

>
> I guess? Not sure I want to fix it - doesn't really seem worth much.
>
That's ok!
