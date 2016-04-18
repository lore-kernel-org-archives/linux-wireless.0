Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35859 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbcDRAIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2016 20:08:06 -0400
Received: by mail-oi0-f43.google.com with SMTP id x201so10969441oif.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2016 17:08:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com>
References: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 18 Apr 2016 10:07:46 +1000
Message-ID: <CAGRGNgV_W6uJF5DR43XdqvHPgBha1AfALYXcX4Lj=4jkO8TftQ@mail.gmail.com> (sfid-20160418_021351_511904_72990C7C)
Subject: Re: [PATCH] ath6kl: Add ability to set debug uart baud rate
To: Steve deRosier <derosier@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steve,

On Sat, Apr 16, 2016 at 10:19 AM, Steve deRosier <derosier@gmail.com> wrote:
> It's useful to permit the customization of the debug uart baud rate. Enable
> this and send down the value to the chip if we're enabling debug.
>
> Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>

This looks like it's using standard serial rates. Does it accept
non-standard rates? If not, should this be checked before being passed
to the hardware?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
