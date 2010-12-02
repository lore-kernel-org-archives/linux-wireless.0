Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33416 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab0LBXcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:32:12 -0500
Received: by iwn42 with SMTP id 42so1515761iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:32:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim0L7e+RZ1v6B3+s_Z7pOZ6KAgvZ_tZEQJnMHET@mail.gmail.com>
References: <AANLkTim0L7e+RZ1v6B3+s_Z7pOZ6KAgvZ_tZEQJnMHET@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Dec 2010 15:31:51 -0800
Message-ID: <AANLkTikq7h3hwVBQBWv+Avhzc6KZLxRC3OkxjpbgwQ8M@mail.gmail.com>
Subject: Re: [PATCH]: ath9k: fix bug in tx power
To: Matteo Croce <technoboy85@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 3:24 PM, Matteo Croce <technoboy85@gmail.com> wrote:
> The ath9k driver subtracts 3 dBm to the txpower as with two radios the
> signal power is doubled.
> The resulting value is assigned in an u16 which overflows and makes
> the card to work at full power.

Thanks for the patch Matteo, can you please reword a bit better and
resubmit by first using checkpatch.pl against the patch? The branch
should be separated by a space.

  Luis
