Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:6938 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZESWZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 18:25:16 -0400
Received: by wf-out-1314.google.com with SMTP id 26so24184wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 15:25:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905191522j37fb71das9289ef580b9e6ff5@mail.gmail.com>
References: <43e72e890905191522j37fb71das9289ef580b9e6ff5@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 May 2009 15:24:58 -0700
Message-ID: <43e72e890905191524i5075b3b1mba83816d4ceb94f6@mail.gmail.com>
Subject: Re: ath9k oops - in ath_get_rate+0x468 - Fatal exception in interrupt
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 3:22 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Johannes -- is this related to the RX race you were
> mentioning?

Actually this is during ieee80211_tx.. so never mind.

  Luis
