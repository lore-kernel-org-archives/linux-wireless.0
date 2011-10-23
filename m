Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60475 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1JWNMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 09:12:53 -0400
Received: by yxl42 with SMTP id 42so2444437yxl.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2011 06:12:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319191502.3964.11.camel@jlt3.sipsolutions.net>
References: <CAG5dHkT8fPodB_ejoqSmH4Dgr-ynuMzwo5r5czXfCWgJWLiS=w@mail.gmail.com>
	<1319191502.3964.11.camel@jlt3.sipsolutions.net>
Date: Sun, 23 Oct 2011 17:12:53 +0400
Message-ID: <CAG5dHkSf3+x5kEBSnq7Q4WjnEr4_oeHz_cMHF_mKJoTOzhzeFw@mail.gmail.com> (sfid-20111023_151258_216158_1B0CB990)
Subject: Re: [RFC 4/7] mac80211: setting link-specific mesh power modes when
 plink open
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2011 14:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-10-21 at 12:37 +0400, Ivan Bezyazychnyy wrote:
>> Setting peer link-specific power mode equal to peer non-peer power mode
>> value and local link-specific power mode equal to local non-peer value
>
> You really need more verbose changelogs, I can't even parse that
> properly. How about mentioning why, what it means, etc?

Yes, I understand.

> You should also extend your cover letter to explain how the power save
> stuff works.
OK. Thank you very much for all comments.

--Ivan
