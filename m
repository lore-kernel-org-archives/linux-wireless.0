Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:35110 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZGaSQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:16:17 -0400
Received: by yxe5 with SMTP id 5so265358yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090731181020.GE7963@makis>
References: <20090731181020.GE7963@makis>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 11:15:56 -0700
Message-ID: <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com>
Subject: Re: [PATCH 4/4] ath5k: Use SWI to trigger calibration
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 11:10 AM, Nick
Kossifidis<mick@madwifi-project.org> wrote:
>  * Get rid of calibration timer, instead use a software interrupt
>   to schedule the calibration tasklet.

An example of itemizing one change. Explain the why, not the how.

  Luis
