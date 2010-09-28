Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:63853 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab0I1Sq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 14:46:29 -0400
Received: by pxi10 with SMTP id 10so1782173pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 11:46:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285699064-16491-1-git-send-email-greearb@candelatech.com>
References: <1285699064-16491-1-git-send-email-greearb@candelatech.com>
Date: Tue, 28 Sep 2010 14:46:27 -0400
Message-ID: <AANLkTikrWHDoGphY+iwvCO0fqoVDJDJPwvkUMePtR87Q@mail.gmail.com>
Subject: Re: [PATCH v5] ath5k: Allow ath5k to support virtual STA and AP interfaces.
From: Bob Copeland <me@bobcopeland.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +               short_preamble = !!(frame_txctl->flags &
> +                                   IEEE80211_TX_SHORT_PREABLE);

Oh, noticed this in the other patch: 'preamble' is misspelled.

-- 
Bob Copeland %% www.bobcopeland.com
