Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:12719 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZBMFmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:42:03 -0500
Received: by yx-out-2324.google.com with SMTP id 8so572836yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:42:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234463938-1350-3-git-send-email-me@bobcopeland.com>
References: <1234463938-1350-3-git-send-email-me@bobcopeland.com>
Date: Thu, 12 Feb 2009 21:42:02 -0800
Message-ID: <43e72e890902122142m38bd03bydddb2300a087c80a@mail.gmail.com> (sfid-20090213_064209_471326_2CD89EF9)
Subject: Re: [ath5k-devel] [PATCH 2/6] ath9k: save a few calls to
	ath9k_regd_get_eepromRD
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 10:38 AM, Bob Copeland <me@bobcopeland.com> wrote:
> Since we already have a stack variable to track the eeprom regd,
> we can grab it up front it and save three calls to fetch it again.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Ackedy-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
