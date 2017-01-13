Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdAMK2j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:28:39 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Michael Renzmann" <mrenzmann@madwifi-project.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
        ath9k-devel@lists.ath9k.org
Subject: Re: Searching new home for ath[59]k-devel mailing lists
References: <49328.217.24.3.26.1483895726.squirrel@webmail.madwifi-project.org>
Date: Fri, 13 Jan 2017 12:28:34 +0200
In-Reply-To: <49328.217.24.3.26.1483895726.squirrel@webmail.madwifi-project.org>
        (Michael Renzmann's message of "Sun, 8 Jan 2017 18:15:26 +0100 (CET)")
Message-ID: <87y3yfi78t.fsf@purkki.adurom.net> (sfid-20170113_112854_508096_F066D703)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Michael Renzmann" <mrenzmann@madwifi-project.org> writes:

> Out of history, the ath5k-devel and ath9k-devel mailing lists have been
> and still are hosted on the mailing list server of the MadWifi project. I
> intend to shut the server down, and thus I'm searching a new loving home
> for the lists.
>
> Besides a new home the lists also need some attention - both would receive
> a fair amount of spam, and thus they need someone who takes care of some
> kind of moderating posts and/or filtering spam.
>
> To be honest, I've not been following things at all for many months. From
> what I can tell it seems that ath5k-devel is pretty quiet. ath9k-devel,
> however, still sees a fair amount of communication; but I didn't look at
> how much of that traffic actually took place here on linux-wireless, just
> CC'ing ath9k-devel.
> This is to say, if there is a broad agreement that one of the lists or
> both of them are no longer required, I'm fine with just closing them in an
> ordered fashion.

I really don't see any need for ath5k-devel, according to git log there
has been five patches for ath5k during the past year.

ath9k is of course a lot more active, 99 patches over the last year. But
still I get the feeling that we don't really need an ath9k specific
mailing list, discussion via linux-wireless should work. And if there
ever comes up a demand to have a dedicated list for ath9k we can then
try find a new one, for example from infradead.org.

So feel free to close both of the lists and thanks for the heads up. Are
you planning to update the MAINTAINERS file or should I?

-- 
Kalle Valo
