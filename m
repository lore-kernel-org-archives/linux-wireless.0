Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f189.google.com ([209.85.222.189]:45698 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0BCSyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 13:54:31 -0500
Received: by pzk27 with SMTP id 27so1756441pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2010 10:54:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265217618-2018-1-git-send-email-senthilkumar@atheros.com>
References: <1265217618-2018-1-git-send-email-senthilkumar@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 3 Feb 2010 10:54:10 -0800
Message-ID: <43e72e891002031054u55b1f7f1sb20e9c203418d501@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: configure the beacon only if the STA is
	associated
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 3, 2010 at 9:20 AM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> beacons configuration SHOULD be done only if the STA is associated.
>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>

I believe this is Cc: stable@kernel.org

  Luis
