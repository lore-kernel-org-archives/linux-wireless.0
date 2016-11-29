Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50854 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755221AbcK2H5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 02:57:52 -0500
Message-ID: <1480406267.10012.0.camel@sipsolutions.net> (sfid-20161129_085755_339172_5AD3D6DD)
Subject: Re: [PATCH 03/12] brcmfmac: move pno helper functions in separate
 source file
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 29 Nov 2016 08:57:47 +0100
In-Reply-To: <CACna6rwSDT1UeuexMpNhVMxKHWpZGdzDg7C1b5wVOhXzO3o=MA@mail.gmail.com> (sfid-20161129_080814_911793_E1764CEC)
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
         <1479896731-5091-4-git-send-email-arend.vanspriel@broadcom.com>
         <CACna6rwSDT1UeuexMpNhVMxKHWpZGdzDg7C1b5wVOhXzO3o=MA@mail.gmail.com>
         (sfid-20161129_080814_911793_E1764CEC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-11-29 at 08:08 +0100, Rafał Miłecki wrote:
> On 23 November 2016 at 11:25, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> > 
> > Introducing new source file for pno related functionality. Moving
> > existing pno functions.
> 
> Let me ask one basic question as I'm curious: what that PNO stands
> for? I couldn't find it explained in the code.

It's an Android term - Preferred Network Offload(ing?)

johannes
