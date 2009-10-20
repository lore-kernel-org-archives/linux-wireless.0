Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:44758 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZJTHtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 03:49:49 -0400
Received: by iwn8 with SMTP id 8so2753353iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 00:49:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2d0a357f0910200046g2a04c1d4v7a62c9e15b403999@mail.gmail.com>
References: <1256018933.4475.6.camel@johannes.local> <2d0a357f0910200033t25c6b848x6d321057b69e47e6@mail.gmail.com>
	<2d0a357f0910200046g2a04c1d4v7a62c9e15b403999@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 20 Oct 2009 16:49:33 +0900
Message-ID: <43e72e890910200049n45db6e2dqa17c67ed48b08362@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: sme: deauthenticate on assoc failure
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2009 at 4:46 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> To clarify on the patchset and order:
>
> [quilt series]:
> # patches from linux-wireless ML
> linux-wireless/0001-Revert-mac80211-fix-SME-warning-by-removing-stale-BS.patch
> linux-wireless/mac80211-keep-auth-state-when-assoc-fails.patch
> linux-wireless/cfg80211-sme-deauthenticate-on-assoc-failure.patch

Yes, a revert is required first.

 Luis
