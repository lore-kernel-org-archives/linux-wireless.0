Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52889 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdHQFdv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 01:33:51 -0400
From: Jay Vosburgh <jay.vosburgh@canonical.com>
To: Dan Williams <dcbw@redhat.com>
cc: David Miller <davem@davemloft.net>, james@nurealm.net,
        futur.andy@googlemail.com, kvalo@codeaurora.org,
        arend.vanspriel@broadcom.com, maheshb@google.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, greearb@candelatech.com
Subject: Re: Regression: Bug 196547 - Since 4.12 - bonding module not working with wireless drivers
In-reply-to: <1502935907.30484.4.camel@redhat.com>
References: <CADps9UCgqeUh41iHxCM+CTJh=Tffn-tiSYL2Q+NBb_8EppqRMA@mail.gmail.com> <2b6fd91a-f7cd-c2bf-6394-060d9b1f5d23@nurealm.net> <1502918561.30484.1.camel@redhat.com> <20170816.143116.1172751167543812070.davem@davemloft.net> <1502935907.30484.4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 16 Aug 2017 22:33:41 -0700
Message-ID: <28296.1502948021@famine> (sfid-20170817_073357_529213_6EF2901D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> wrote:
[...]
>You'll probably say "aim for the 75% case" or something like that,
>which is fine, but then you're depending on your 75% case to be (a)
>single AP, (b) never move (eg, only bond wifi + ethernet), (c) little
>radio interference.  I'm not sure I'd buy that.  If I've put words in
>your mouth, forgive me.

	The primary use case that I'm aware of for bonding with wireless
devices is in active-backup mode, paired with an ethernet adapter set as
the bonding "primary" device.  I think this is the case that absolutely
should just work.  I don't think bonding cares (or should care) about
(a) - (c) for this use.

	Your point (b) suggests that there are use cases other than the
above; I'm unfamiliar with any use other than wifi + ethernet, can you
elaborate?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
