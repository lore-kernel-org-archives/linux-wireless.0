Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:34782 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752351AbdBUSwe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 13:52:34 -0500
MIME-Version: 1.0
In-Reply-To: <20170221.131858.949421414784612398.davem@davemloft.net>
References: <alpine.LSU.2.20.1702201508280.24579@cbobk.fhfr.pm>
 <CA+55aFxLmgA7drrGfUJmCRPT-A74ROYf6GQHFGO5pzVjZ0dL7Q@mail.gmail.com>
 <87d1eb99dq.fsf_-_@purkki.adurom.net> <20170221.131858.949421414784612398.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2017 10:52:33 -0800
Message-ID: <CA+55aFyqH3WAKsD_AaCe905zJbPzTXGygu2eiD1L0d6c2sAkGA@mail.gmail.com> (sfid-20170221_195302_373615_E1A7F486)
Subject: Re: ath10k regression on XPS13
To: David Miller <davem@davemloft.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, Jiri Kosina <jikos@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:QUALCOMM ATHEROS ATH10K WIRELESS DRIVER"
        <ath10k@lists.infradead.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 21, 2017 at 10:18 AM, David Miller <davem@davemloft.net> wrote:
>
> Kalle I really wanted to send my net-next pull request to Linus later
> today.  But I guess I have to wait for this ath10k first.

Feel free to send it to me - it sounds like the regression is
 (a) easy to work around
and
 (b) has a fix coming up.

And it won't even be something that I personally notice, since I have
the prev-gen XPS13 that has intel wireless.

              Linus
