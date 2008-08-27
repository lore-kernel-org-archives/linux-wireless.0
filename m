Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:19707 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYH0Lmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 07:42:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1078427nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2008 04:42:43 -0700 (PDT)
Message-ID: <1ba2fa240808270442k20f70e69n6a6203d236376f5@mail.gmail.com> (sfid-20080827_134252_444662_16EFA7C4)
Date: Wed, 27 Aug 2008 14:42:43 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: holtmann@linux.intel.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <20080827.033237.236091327.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080827.014041.230100807.davem@davemloft.net>
	 <1219835410.5359.24.camel@californication>
	 <1ba2fa240808270305m7f505efak9fd0d36d5db09a1e@mail.gmail.com>
	 <20080827.033237.236091327.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 27, 2008 at 1:32 PM, David Miller <davem@davemloft.net> wrote:
> From: "Tomas Winkler" <tomasw@gmail.com>
> Date: Wed, 27 Aug 2008 13:05:23 +0300
>
>> There is a central problem here, since I cannot really adjust driver
>> development progress from obvious reason with Linux merging window.
>
> Indeed, that's exactly what your core problem is.
>
> You think it's OK to contaminate upstream just because of the
> way you have choosen to maintain your driver.
>

I don't think I contaminate upstream I'm just trying to fix bugs so
people can work with the HW.

> Well guess what, it's not OK to do that, and it's absolutely not our
> problem that you choose to do your development in the most anti-social
> way possible wrt. upstream.
>
> Anyways, keep defending yourself.

I'm not defending myself I'm explaining myself.

> If you persist, I can certainly make things _really_ easy, such that
> if there isn't a regression list entry for the bug you are fixing and
> it isn't mentioned explicitly in your commit message, I simply will
> refuse to take your changes outside of the merge window.
>
> It's that simple.
>
> Would you like things to work that way, where I'm a hard ass, or would
> you like to stop defending yourself endlessly, and instead start to be
> reasonable?

I'm not sure why you are so militant, you cut out form my email sentences
like 'Yes' and 'Understood'
Is this personal ?

Tomas
