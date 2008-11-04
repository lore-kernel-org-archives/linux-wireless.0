Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:23770 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYKDIip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 03:38:45 -0500
Received: by rv-out-0506.google.com with SMTP id k40so3130140rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 00:38:44 -0800 (PST)
Message-ID: <1ba2fa240811040038y54b20a46y88e2b849f98c78cf@mail.gmail.com> (sfid-20081104_093854_262731_C1099CD5)
Date: Tue, 4 Nov 2008 10:38:44 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>, tim.gardner@canonical.com,
	mick@madwifi.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <87ljw0arrq.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4908B754.1050400@tpi.com>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
	 <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	 <1225698867.3619.31.camel@johannes.berg>
	 <43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com>
	 <1225699482.3619.34.camel@johannes.berg> <87ljw0arrq.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2008 at 9:12 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>>> > Also,
>>> > that's a bad thing to do in userspace, imho.
>>>
>>> What should we do with these rare failures then?
>>
>> print an error message? ignore them? try again?
>
> I would say that try few (three?) times and if it still fails, restart
> firmware and push the same settings again to the firmware. There's
> very little that mac80211 could do here, driver has to make the
> decisions in case like this.

Mac should be aware that card is iin TODO list.
Tomas
