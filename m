Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:4450 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZBMFu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:50:28 -0500
Received: by yw-out-2324.google.com with SMTP id 5so575014ywh.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:50:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234463938-1350-7-git-send-email-me@bobcopeland.com>
References: <1234463938-1350-7-git-send-email-me@bobcopeland.com>
Date: Thu, 12 Feb 2009 21:50:26 -0800
Message-ID: <43e72e890902122150n3964d5eud19ffce7577fb60c@mail.gmail.com> (sfid-20090213_065031_951039_6F1FA471)
Subject: Re: [ath5k-devel] [PATCH 6/6] ath9k: move common regulatory code out
	of if() branches
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 10:38 AM, Bob Copeland <me@bobcopeland.com> wrote:
> Both branches of the regulatory check in ath_attach() set up a
> custom regulatory domain and apply radar and world flags, so extract
> those into a single path.
>
> While at it, fix a couple of spelling errors and an unnecessary extra
> pointer traversal.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
