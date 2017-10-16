Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0076.outbound.protection.outlook.com ([104.47.37.76]:51898
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751358AbdJPJoM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 05:44:12 -0400
Date: Mon, 16 Oct 2017 12:43:59 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
Message-ID: <20171016094358.ye7x6yc2m2u6qdrw@bars> (sfid-20171016_114420_118535_C21F8700)
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
 <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com>
 <20171015095133.prxuuukv6osx52td@bars>
 <1508138777.10607.14.camel@sipsolutions.net>
 <20171016084810.plzog2dtzakra4ae@bars>
 <1508145899.10607.30.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508145899.10607.30.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Let me know if you have any objections to implementation details :)
> 
> Yeah, I'll need to review it, just need a bit more time for that.
> 
> > Then I will resubmit it addressing all the comments. Besides I am
> > going to change command name from 'capture' to 'dump' to avoid
> > confusion. Finally, I will update commit message adding information
> > about unicast nature of those registrations.
> 
> Sounds good :)
> 
> Do you want to resend before I review it?

No, I will wait for code reviews, then I will resend the updated
patch including changes for all the upcoming comments.

Regards,
Sergey
