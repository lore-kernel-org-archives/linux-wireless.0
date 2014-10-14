Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaJNHPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 03:15:16 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Sir l33tname <l33tname@outlook.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: r8723au module
References: <BLU437-SMTP3548C40225183D5FB08040C3AC0@phx.gbl>
Date: Tue, 14 Oct 2014 09:15:09 +0200
In-Reply-To: <BLU437-SMTP3548C40225183D5FB08040C3AC0@phx.gbl> (Sir's message
	of "Mon, 13 Oct 2014 21:26:49 +0200")
Message-ID: <wrfjlhojktqa.fsf@redhat.com> (sfid-20141014_091521_808699_72433AF5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sir l33tname <l33tname@outlook.com> writes:
> Hey,
>
>
> Since r8723au is out I have tried it with every kernel version.
> But every time the connection is flaky, it works fine in the beginning
> but after ~2 - 5 minutes it stops routing packages get slow, but
> it shows all the time connected (on my wlan widget). With 8723au build
> from github, none of this problems exist. (Probably because I build
> with out Bluetooth?)
>
>
> Output of modinfo
> https://gist.github.com/fliiiix/f32d8be6c7759e318088
>
> Since I have no idea what you need to debug this, please just
> ask for what I should try or what output do you like to see.

Hi,

Can you provide some information about the wireless access point you are
connected to? Speeds, crypto used, etc.

Jes
