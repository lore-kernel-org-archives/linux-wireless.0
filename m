Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57648 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752493AbdDCVjP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 17:39:15 -0400
Date: Tue, 4 Apr 2017 07:39:10 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tycho Andersen <tycho@tycho.ws>,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH RFC] remove custom Michael MIC implementation
Message-ID: <20170403213910.GA7480@eros> (sfid-20170403_233950_288643_89A1EB57)
References: <1490935659-7196-1-git-send-email-me@tobin.cc>
 <20170331075851.GB1435@katana>
 <20170331102113.GA2930@eros>
 <87fuhq6par.fsf@purkki.adurom.net>
 <20170403090359.GK3755@eros>
 <87y3vhx1ju.fsf@alrua-karlstad>
 <9bfd1405-fd32-e896-b6f0-09ffedeaac33@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <9bfd1405-fd32-e896-b6f0-09ffedeaac33@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 03, 2017 at 12:15:15PM +0200, Arend Van Spriel wrote:
> seems we are missing out again?

Sorry, I don't understand what this comment means?

> On 3-4-2017 11:50, Toke Høiland-Jørgensen wrote:
> > "Tobin C. Harding" <me@tobin.cc> writes:
> > 
> >> Except one: do you know off the top of your head of a canonical
> >> implementation of a softmac wi-fi driver.
> > 
> > I'll suggest taking a look at the ath9k driver :)
> 
> Looking at ks7010 driver it looks like it has 802.11 stack in firmware
> and not sure if Renesas is actively supporting this effort to come up
> with mac80211-friendly firmware or provide detailed chip info.

Thanks for taking a look. If the ks7010 driver has 802.11 stack in
firmware does that mean it is not compatible with using the kernel
mac80211 stack with the current firmware? I do not have my hopes up
about getting any chip information out of Renesas, all I think we have
to go in is the current WEXT driver.

This is an exercise in learning for me, but I do not want to take any
ones time up with a project that is not that useful. Is getting the
ks7010 driver out of staging something that is of use to the kernel
community or are there other wi-fi tasks that our time is better spent
on?

thanks,
Tobin.
