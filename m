Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54892 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbbAHDQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 22:16:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21677.63268.657151.679992@gargle.gargle.HOWL> (sfid-20150108_041646_416344_C25842CA)
Date: Thu, 8 Jan 2015 08:49:00 +0530
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries
In-Reply-To: <87bnmapiur.fsf@kamboji.qca.qualcomm.com>
References: <1419685980-4728-1-git-send-email-arend@broadcom.com>
	<87bnmapiur.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Arend van Spriel <arend@broadcom.com> writes:
> 
> > Use the helper to get rid of the file operations per debugfs file. The
> > device driver data contains struct ieee80211_hw pointer and the
> > struct ath9k_softc pointer is assigned to ieee80211_hw::priv so it can
> > be accessed in the seq_file read operation.
> >
> > Cc: ath9k-devel@lists.ath9k.org
> > Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks for the patch.

> Can someone with ath9k hardware test this, please? I'm hesitant to apply
> this without testing.

I tested it and there were no crashes.

Sujith
