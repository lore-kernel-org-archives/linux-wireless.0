Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:41802 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbZINSMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 14:12:09 -0400
Received: by vws33 with SMTP id 33so556802vws.33
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 11:12:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252919221-13628-1-git-send-email-lrodriguez@atheros.com>
References: <1252919221-13628-1-git-send-email-lrodriguez@atheros.com>
Date: Mon, 14 Sep 2009 14:12:12 -0400
Message-ID: <b6c5339f0909141112i3f4b6916i659c18bf1da798d2@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ath5k: define ath_common ops
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 5:07 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Only common ath read/write ops go through the common ops.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Thanks Luis, looks good to me too.

-- 
Bob Copeland %% www.bobcopeland.com
