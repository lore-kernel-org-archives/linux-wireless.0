Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59994 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1JCS6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 14:58:44 -0400
Received: by qadb15 with SMTP id b15so1819024qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 11:58:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317637758-11907-7-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <1317637758-11907-7-git-send-email-zefir.kurtisi@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 3 Oct 2011 11:30:24 -0700
Message-ID: <CAB=NE6Wn20tCsv-gdSCcmdDr0pHyEavxyufaj-ga-1DfNQAxOg@mail.gmail.com> (sfid-20111003_205849_154861_1F948B2C)
Subject: Re: [RFC 6/6] ath9k: handle pulse data reported by DFS HW
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> Note: calculation of mactime had to be shifted before
> ath9k_rx_skb_preprocess() since it is used to time-stamp the
> radar pulse.

Do this in a separate patch and provide a valid commit log here of
what the addition actually does. As I see it you can unify the last
set of patches together. The debugfs stuff can be kept apart though
but with the considerations I mentioned.

  Luis
