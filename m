Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:38810 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZIJLEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 07:04:00 -0400
Received: by vws33 with SMTP id 33so2780142vws.33
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 04:04:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252566619-30390-8-git-send-email-lrodriguez@atheros.com>
References: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
	 <1252566619-30390-8-git-send-email-lrodriguez@atheros.com>
Date: Thu, 10 Sep 2009 07:04:03 -0400
Message-ID: <b6c5339f0909100404g37efa271i94c63ffa1f15e6f9@mail.gmail.com>
Subject: Re: [PATCH 7/7] atheros: use get_unaligned_le*() for bssid mask
	setting
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, devel@linuxdriverproject.org,
	Nick Kossifidis <mick@madwifi-project.org>,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 3:10 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> -       /* MAC may be NULL if it's a broadcast key. In this case no need to
> -        * to compute AR5K_LOW_ID and AR5K_HIGH_ID as we already know it. */
> +       /*
> +        * MAC may be NULL if it's a broadcast key. In this case no need to
> +        * to compute get_unaligned_le32 and get_unaligned_le16 as we
> +        * already know it.
> +        */

Maybe not this one... but otherwise ACK :)

-- 
Bob Copeland %% www.bobcopeland.com
