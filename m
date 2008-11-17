Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.189]:2545 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbYKQVTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 16:19:12 -0500
Received: by gv-out-0910.google.com with SMTP id e6so456755gvc.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 13:19:11 -0800 (PST)
Message-ID: <3ace41890811171319w209d45c1ufd9f2a664e292383@mail.gmail.com> (sfid-20081117_221918_566215_932C398D)
Date: Mon, 17 Nov 2008 21:19:10 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: Re: [PATCH] rtl8187: Fix transmission count sent to mac80211
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200811171829.22930.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <492188e5.bIuOh01ilT9fPRTO%Larry.Finger@lwfinger.net>
	 <200811171742.48292.herton@mandriva.com.br>
	 <1226951228.3902.55.camel@johannes.berg>
	 <200811171829.22930.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 8:29 PM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
<sniped>
> Ah nice, I didn't saw it, I'm usually lagging reading mail... I saw it now.
>
> Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Tried the one-liner change on top of wireless-testing. Works alright
- no noticeable regression.

BTW, i don't check my gmail account as often than the other account
(and the sf accounts redirects
to that other account).

Hin-Tak
