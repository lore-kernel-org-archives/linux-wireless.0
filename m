Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:21652 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYG2IiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 04:38:01 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3311666waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 01:38:00 -0700 (PDT)
Message-ID: <1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com> (sfid-20080729_103808_739612_964A20D3)
Date: Tue, 29 Jul 2008 11:38:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1217320089.15381.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
	 <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	 <1217320089.15381.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 11:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 11:23 +0300, Tomas Winkler wrote:
>> On Tue, Jul 29, 2008 at 9:53 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2008-07-29 at 00:21 -0300, Herton Ronaldo Krzesinski wrote:
>> >
>> >> [3] /sbin/iwconfig wlan0 power on
>> >
>> > I don't think turning on power management (yes, this command is
>> > completely misnamed, it turns on power _management_ not the power, you
>> > may want "txpower auto") does anything on this chip, does it?
>> >
>> iwconfig power on is not implemented by mac80211 yet. There was one
>> patch posted that implements it.
>> I wanted to expand it but  wireless_tools 29 has a bug in parsing this
>> command. It is fixed only in 30.pre6 which is usually not in distros.
>
> Heh, fun. Time for putting that into cfg80211 instead if nobody can use
> it with wext anyway?

I've planned to but I waited for some API design suggestions  you guys
will come from OLS but I didn't get much input.
Tomas
