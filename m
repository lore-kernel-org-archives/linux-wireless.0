Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51859 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab0LGTNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 14:13:16 -0500
Received: by qyk11 with SMTP id 11so5350682qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 11:13:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291169919-3867-1-git-send-email-javier@cozybit.com>
References: <1291169919-3867-1-git-send-email-javier@cozybit.com>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 7 Dec 2010 11:12:55 -0800
Message-ID: <AANLkTik5bGXyWsz0CeVemZ-s9uWC+SOyJNzfxr1vcoGt@mail.gmail.com>
Subject: Re: ath5k: Fixes for mesh operation
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Are you waiting for acks from ath5k maintainers to apply this series?

https://patchwork.kernel.org/patch/369461/
https://patchwork.kernel.org/patch/369471/
https://patchwork.kernel.org/patch/369481/

Thanks!

Javier

On Tue, Nov 30, 2010 at 6:18 PM, Javier Cardona <javier@cozybit.com> wrote:
> After applying these fixes we were able to successfully bring up mesh
> interfaces and establish peer links with ath9k devices.
>
> One issue still looms with both athX drivers:  you have to issue a scan to get
> mesh beaconing started.  Keep that in mind if you try and test these fixes.
>
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
