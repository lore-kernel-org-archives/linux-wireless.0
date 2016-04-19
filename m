Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2887 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbcDSNA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 09:00:58 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Steve deRosier <derosier@gmail.com>
CC: Julian Calaby <julian.calaby@gmail.com>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: Re: [PATCH] ath6kl: Add ability to set debug uart baud rate
Date: Tue, 19 Apr 2016 13:00:54 +0000
Message-ID: <87lh493g8r.fsf@qca.qualcomm.com> (sfid-20160419_150102_213242_CBFBB299)
References: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com>
	<CAGRGNgV_W6uJF5DR43XdqvHPgBha1AfALYXcX4Lj=4jkO8TftQ@mail.gmail.com>
	<CALupW3CsuSGy=xBw-Wj5FfD+ALKBGi9xvi=Z8+YTdL9mGku5HQ@mail.gmail.com>
In-Reply-To: <CALupW3CsuSGy=xBw-Wj5FfD+ALKBGi9xvi=Z8+YTdL9mGku5HQ@mail.gmail.com>	(Steve
 deRosier's message of "Mon, 18 Apr 2016 11:12:41 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> On Sun, Apr 17, 2016 at 5:07 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Steve,
>>
>> This looks like it's using standard serial rates. Does it accept
>> non-standard rates? If not, should this be checked before being passed
>> to the hardware?
>>
>
> It should use standard serial rates, and obviously I defaulted it to a
> sensible one. However, there's nothing that prevents you from using
> odd and arbitrary rates in the firmware and it should just suck it in
> and use it. In other words, the firmware will happily try to set 9507
> baud if you tell it to.
>
> This is specifically for debugging and working with the firmware and
> IMHO, if you are using this feature and feel a need to set it to
> something weird, I think the user should be allowed to. If you know
> enough to be able to shoot yourself in the foot with this, then you
> should know enough of what you should or shouldn't do and should be
> allowed to. It's a debugging tool only and I don't see any reason to
> waste lines in the driver to validate this input.

I think likewise, normal users shouldn't touch this setting at all.

-- 
Kalle Valo