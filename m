Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33270 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbbJMWmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 18:42:35 -0400
Received: by wicge5 with SMTP id ge5so77826833wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2015 15:42:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444727650.1961.10.camel@sipsolutions.net>
References: <1444635356-19975-1-git-send-email-ola1olsson@gmail.com>
	<1444727650.1961.10.camel@sipsolutions.net>
Date: Wed, 14 Oct 2015 00:42:34 +0200
Message-ID: <CABAco3CLCtFOofHMbJSz-Okcc4BM4nnVwO5By8DeZUYJrsCt6Q@mail.gmail.com> (sfid-20151014_004239_268062_761E6DDC)
Subject: Re: [PATCH] ocb: use correct "MHz" instead of "MHZ"
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Absolutely, I will do that.

May I ask if you are interested in patches that removes the compiler
warnings on Android? I have cloned the iw git under the external
folder in the android tree and everything compiles fine with "mm" but
there are a lot of warnings. Most warnings are unused-parameter and
sign-compare but also missing-field-initializers.
None of them are critical but it is way easier to introduce new ones
if the screen is full of them already.The patches are ready in case
you are interested.


/Ola

On Tue, Oct 13, 2015 at 11:14 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi Ola,
>
> Thanks for all the patches - I just applied this and three others.
>
> Note that I've reworded the subject for some - I prefer the subject to
> state in active voice what the change is doing - i.e. be something you
> read before the actual change, rather than afterwards. I'd appreciate
> if you could do the same for future patches.
>
> Thanks,
> johannes
