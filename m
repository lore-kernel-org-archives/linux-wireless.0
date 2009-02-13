Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:14311 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZBMFjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:39:45 -0500
Received: by el-out-1112.google.com with SMTP id b25so731798elf.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:39:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234463938-1350-2-git-send-email-me@bobcopeland.com>
References: <1234463938-1350-2-git-send-email-me@bobcopeland.com>
Date: Thu, 12 Feb 2009 21:39:43 -0800
Message-ID: <43e72e890902122139h53ab1e94m9a7d2b22c0f08a9a@mail.gmail.com> (sfid-20090213_063948_777710_45F52DC6)
Subject: Re: [ath5k-devel] [PATCH 1/6] ath9k: remove write-only
	current_rd_inuse
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 10:38 AM, Bob Copeland <me@bobcopeland.com> wrote:
> The current_rd_inuse regulatory value is assigned but not used anywhere.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
