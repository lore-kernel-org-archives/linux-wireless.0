Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33592 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZUTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 16:19:22 -0400
Received: by oagh16 with SMTP id h16so1033968oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 13:19:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFtRNNzCFHe43iCn7G9h-4tjGhWCPpG3ProXnM-zdiDt8h4M2g@mail.gmail.com>
References: <1348511419-11881-1-git-send-email-linville@tuxdriver.com>
	<CAFtRNNzCFHe43iCn7G9h-4tjGhWCPpG3ProXnM-zdiDt8h4M2g@mail.gmail.com>
Date: Wed, 26 Sep 2012 13:19:21 -0700
Message-ID: <CAJ-VmonR_5ng2yKTR2ePyi61xk4XeM_7_zvZd6Q56Fbi_LQyfA@mail.gmail.com> (sfid-20120926_221925_964818_30AB48F5)
Subject: Re: [PATCH] ath5k: add missing breaks in ath5k_hw_set_spur_mitigation_filter
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	David Binderman <dcb314@hotmail.com>, me@bobcopeland.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2012 12:33, Nick Kossifidis <mickflemm@gmail.com> wrote:

> The idea is that we don't know if these settings for half/quarter rate
> channels even work (that's why I've put the question marks there), I
> just put them there so that others can see them / test them and report
> back (mostly people working on 802.11p with ath5k). Without the breaks
> it always uses the default witch is what we have from HAL sources.
>
> Anyway I guess enabling them will result more testing and if something
> breaks we 'll hear from the 802.11p people soon, so

Well, I know the HAL code in FreeBSD implements half/quarter rate
"right" for the ar5k series chips that do support it (save the odd
frequency channel centre mis-calculation).. that's due to chip RF
synth limitations though.

So the HAL code in FreeBSD should be fine as a reference.


Adrian
