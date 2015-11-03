Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35853 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbKCJhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:37:46 -0500
Received: by wmec75 with SMTP id c75so81089879wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2015 01:37:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446472988-2603-8-git-send-email-michal.kazior@tieto.com>
References: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
	<1446472988-2603-8-git-send-email-michal.kazior@tieto.com>
Date: Tue, 3 Nov 2015 10:37:45 +0100
Message-ID: <CA+BoTQmqyTnGU9_cp_GKkXXm5FVbWLN1rAPZBioEk030UyL-tg@mail.gmail.com> (sfid-20151103_104116_036425_54AEF66A)
Subject: Re: [PATCH 7/8] ath10k: replace vdev_id and tid in skb cb
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 November 2015 at 15:03, Michal Kazior <michal.kazior@tieto.com> wrote:
> This prepares the driver for future ieee80211_txq
> and wake_tx_queue() support.

I think I've found a regression and bisect blames this patch. Do not
apply this yet, please.


Michał
