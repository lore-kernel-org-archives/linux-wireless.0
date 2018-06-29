Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753431AbeF2IGi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 04:06:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Optimising maintainer's time
References: <20180413061613.8569-1-pkshih@realtek.com>
        <1527734181.8418.13.camel@realtek.com>
Date: Fri, 29 Jun 2018 11:06:33 +0300
In-Reply-To: <1527734181.8418.13.camel@realtek.com> (pkshih@realtek.com's
        message of "Thu, 31 May 2018 02:36:38 +0000")
Message-ID: <87o9fuf246.fsf_-_@codeaurora.org> (sfid-20180629_100649_585325_20EB4C04)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Was "Re: [PATCH v4 0/9] rtlwifi: btcoex: Add 8822b btcoex support" but
I'll change the title to get more visibility as this is a general advice
for everyone)

Pkshih <pkshih@realtek.com> writes:

> I would like to send v5 to change the order of this patchset like:
> =C2=A0 rtlwifi: btcoex: remove comments that are not meaningful
> =C2=A0 rtlwifi: btcoex: Add modifier const to version related variables
> =C2=A0 rtlwifi: btcoex: Add struct members to replace global varaibles
> =C2=A0 rtlwifi: btcoex: Remove global variables of chip specific context
>
> =C2=A0 rtlwifi: btcoex: Add 8822b1ant coex files
> =C2=A0 rtlwifi: btcoex: Add 8822b2ant coex files
> =C2=A0 rtlwifi: btcoex: Add 8822b header files to precomp.h
> =C2=A0 rtlwifi: btcoex: Add 8822b to Makefile
> =C2=A0 rtlwifi: btcoex: Add 8822b routine to btc interfaces
>
> Then, you can review patches 1/9 - 4/9 that refine btcoex, and the
> remaining 8822b's btcoex can review later. Does it work for you?

I have forgotten the details already so I can't really comment about
this patchset.

But what I can say is that you need to consider maintainer's time, it's
usually limited (all maintainers are busy). If my time is abused (in
networking terms) there will be bufferbloat and I need to start doing
fair queing, and nobody wants that :)

So whenever you are submitting patches consider how you can most
effectively optimise maintainer's time (size of patches, quality of
code, following the rules etc). When you do that, over time you will
notice that your patches get applied faster. But if you do the opposite,
you will notice that it takes longer and harder to get your patches in.

--=20
Kalle Valo
