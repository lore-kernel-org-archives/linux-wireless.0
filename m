Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:39062 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYG2IXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 04:23:30 -0400
Received: by rv-out-0506.google.com with SMTP id k40so4902418rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 01:23:30 -0700 (PDT)
Message-ID: <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com> (sfid-20080729_102334_767028_27D9A024)
Date: Tue, 29 Jul 2008 11:23:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1217314430.15381.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 9:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 00:21 -0300, Herton Ronaldo Krzesinski wrote:
>
>> [3] /sbin/iwconfig wlan0 power on
>
> I don't think turning on power management (yes, this command is
> completely misnamed, it turns on power _management_ not the power, you
> may want "txpower auto") does anything on this chip, does it?
>
iwconfig power on is not implemented by mac80211 yet. There was one
patch posted that implements it.
I wanted to expand it but  wireless_tools 29 has a bug in parsing this
command. It is fixed only in 30.pre6 which is usually not in distros.

Tomas
