Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:34474 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdDCKPU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 06:15:20 -0400
Received: by mail-qt0-f179.google.com with SMTP id n21so107629139qta.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 03:15:20 -0700 (PDT)
Subject: Re: [PATCH RFC] remove custom Michael MIC implementation
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "Tobin C. Harding" <me@tobin.cc>
References: <1490935659-7196-1-git-send-email-me@tobin.cc>
 <20170331075851.GB1435@katana> <20170331102113.GA2930@eros>
 <87fuhq6par.fsf@purkki.adurom.net> <20170403090359.GK3755@eros>
 <87y3vhx1ju.fsf@alrua-karlstad>
Cc: Kalle Valo <kvalo@codeaurora.org>, Tycho Andersen <tycho@tycho.ws>,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9bfd1405-fd32-e896-b6f0-09ffedeaac33@broadcom.com> (sfid-20170403_121547_266852_477EB3F6)
Date: Mon, 3 Apr 2017 12:15:15 +0200
MIME-Version: 1.0
In-Reply-To: <87y3vhx1ju.fsf@alrua-karlstad>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

seems we are missing out again?

On 3-4-2017 11:50, Toke Høiland-Jørgensen wrote:
> "Tobin C. Harding" <me@tobin.cc> writes:
> 
>> Except one: do you know off the top of your head of a canonical
>> implementation of a softmac wi-fi driver.
> 
> I'll suggest taking a look at the ath9k driver :)

Looking at ks7010 driver it looks like it has 802.11 stack in firmware
and not sure if Renesas is actively supporting this effort to come up
with mac80211-friendly firmware or provide detailed chip info.

Regards,
Arend
