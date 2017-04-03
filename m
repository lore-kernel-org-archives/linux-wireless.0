Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36653 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751904AbdDCKAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 06:00:23 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kalle Valo <kvalo@codeaurora.org>, Tycho Andersen <tycho@tycho.ws>,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH RFC] remove custom Michael MIC implementation
References: <1490935659-7196-1-git-send-email-me@tobin.cc>
        <20170331075851.GB1435@katana> <20170331102113.GA2930@eros>
        <87fuhq6par.fsf@purkki.adurom.net> <20170403090359.GK3755@eros>
Date: Mon, 03 Apr 2017 11:50:29 +0200
In-Reply-To: <20170403090359.GK3755@eros> (Tobin C. Harding's message of "Mon,
        3 Apr 2017 19:03:59 +1000")
Message-ID: <87y3vhx1ju.fsf@alrua-karlstad> (sfid-20170403_120100_243065_BC71CBF7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Tobin C. Harding" <me@tobin.cc> writes:

> Except one: do you know off the top of your head of a canonical
> implementation of a softmac wi-fi driver.

I'll suggest taking a look at the ath9k driver :)

-Toke
