Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:27112 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYG2J07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 05:26:59 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3326898waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 02:26:58 -0700 (PDT)
Message-ID: <1ba2fa240807290226n19ab0944u8e27f40cb688cfcc@mail.gmail.com> (sfid-20080729_112704_491958_9E888191)
Date: Tue, 29 Jul 2008 12:26:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1217322974.10489.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
	 <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	 <1217320089.15381.25.camel@johannes.berg>
	 <1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com>
	 <1217322974.10489.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 12:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 11:38 +0300, Tomas Winkler wrote:
>
>> >> iwconfig power on is not implemented by mac80211 yet. There was one
>> >> patch posted that implements it.
>> >> I wanted to expand it but  wireless_tools 29 has a bug in parsing this
>> >> command. It is fixed only in 30.pre6 which is usually not in distros.
>> >
>> > Heh, fun. Time for putting that into cfg80211 instead if nobody can use
>> > it with wext anyway?
>>
>> I've planned to but I waited for some API design suggestions  you guys
>> will come from OLS but I didn't get much input.
>
> This particular thing I don't remember talking about except that we
> want, when powersave is on, be able to select the powersaving level
> based on information applications attach to their sockets, rather than
> requiring the user to make a guess.

PS setting is rather global NIC state and should be set as user
preference rather then per application ... socket. If I understand
correctly what you mean by application.
What user actually selects is performance/power consumption trade off.
Tomas.



> johannes
>
