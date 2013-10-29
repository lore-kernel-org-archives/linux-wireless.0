Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34806 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab3J2NRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 09:17:14 -0400
Received: by mail-lb0-f179.google.com with SMTP id w6so6916lbh.10
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 06:17:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383048716-5886-2-git-send-email-janusz.dziedzic@tieto.com>
References: <1383048716-5886-1-git-send-email-janusz.dziedzic@tieto.com> <1383048716-5886-2-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 29 Oct 2013 14:16:52 +0100
Message-ID: <CAB=NE6V_b7WN997sNb8pYXQLT=H-Zo1xdVdvQZRkJAXwEBB_sg@mail.gmail.com> (sfid-20131029_141717_051327_A7A26362)
Subject: Re: [PATCH v2 2/2] cfg80211: allow beaconing after DFS CAC
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 29, 2013 at 1:11 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> After going throught the Channel Availability Check (CAC)
> required by DFS enable beaconing. Channels that have
> gone through a CAC will be in the NL80211_DFS_AVAILABLE
> state. Without this change APs don't start beaconing
> after a successful CAC.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

This looks better but please merge the two patches together. Also
Johannes -- will this patch need to rely on the new no-ir patch? I
provided feedback on your concern there.

  Luis
