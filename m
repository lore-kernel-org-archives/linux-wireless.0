Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:14220 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaIIUYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 16:24:08 -0400
Message-ID: <540F61D0.9000704@hartkopp.net> (sfid-20140909_222423_112655_D4FAE4E6)
Date: Tue, 09 Sep 2014 22:23:44 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: iwlwifi no authentication with AP - Re: pull request: wireless-next
 2014-09-08
References: <20140908191630.GB29412@tuxdriver.com>	<540F5927.7000306@hartkopp.net> <CANUX_P3n0v1SzfbYuaAsE4TY7Hz_wo2Fb9SmHVNyFOC9hDhwdg@mail.gmail.com>
In-Reply-To: <CANUX_P3n0v1SzfbYuaAsE4TY7Hz_wo2Fb9SmHVNyFOC9hDhwdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09.09.2014 22:02, Emmanuel Grumbach wrote:
> On Tue, Sep 9, 2014 at 10:46 PM, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>> Hello John, all,
>>
>> on my i7 Laptop with iwlwifi the latest net-next does not connect to my access point:
> 
> Are you sure this wasn't the case before?

Indeed I moved to net-next right today - as I also had the LED lockdep splat
on 3.17-rcX with X < 4.

So it can be that this issue was already introduced at the beginning of this
net-next cycle. Don't know, sorry. The latest 3.17-rc4 from Linus' tree works
fine. I'm running a Debian unstable here (in both cases).

> Can you bisect?

Not really. I'm running the kernel on my bare machine - and I just wanted to
go to bed right now ...

So I will be able to test patches tomorrow morning again.

Tnx for your fast feedback,
Oliver

