Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38282 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaCRPwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 11:52:39 -0400
Received: by mail-ie0-f173.google.com with SMTP id rl12so7370139iec.4
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 08:52:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 18 Mar 2014 17:52:39 +0200
Message-ID: <CAB3XZEfb4Vh29-f-vkRY8--UUyN5cHR_nKy+AW_dVFWGXpE25A@mail.gmail.com> (sfid-20140318_165243_774259_E80147BE)
Subject: Re: [RFC 00/21] cfg80211/mac80211: multi-vif csa
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> I'm aware this is rather huge. I'm hoping I can
> get some early feedback before all other patches
> I'm depending on are finally merged into
> mac80211-next.
>
> Considering current dependency hell of all related
> the patchsets I'm duplicating some of my patches
> I've posted on the mailing list here. Hopefully
> this is sane enough for reviewing purposes.
>
> The patchset alone is based on:
>  * mac80211-next/master
>  * VLAN chanctx copy refactor
>  * Luca's intf combination patches
>  * Luca's chanctx reservation patches
>
it could be nice to have some unified branch somewhere with all these
patchsets. :)
(i tried doing it locally, but encountered merging errors)

Eliad.
