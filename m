Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:38214 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932846AbdDFJE5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 05:04:57 -0400
Message-ID: <1491469492.10783.7.camel@hadess.net> (sfid-20170406_110513_823287_DFED3FD6)
Subject: Re: [PATCH] staging: Add rtl8723bs sdio wifi driver
From: Bastien Nocera <hadess@hadess.net>
To: Hans de Goede <hdegoede@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 06 Apr 2017 11:04:52 +0200
In-Reply-To: <5d15c6e8-7c15-4226-c4be-d8db6ded29ef@redhat.com>
References: <20170329174751.13184-1-hdegoede@redhat.com>
         <4d1d3c02-eff6-0410-cee0-9360ec645e13@lwfinger.net>
         <d5fc988b-2962-9c44-7eac-96dba606f56a@redhat.com>
         <a848408c-edd9-075b-1bd5-8e77ca4f42f9@broadcom.com>
         <049673a4-647b-a270-bb9c-15bb2ab49fc4@redhat.com>
         <c9a1b5a2-d0a9-bb92-2d70-c54cc7bf1f8d@lwfinger.net>
         <560981e0-e1b0-7a06-80e4-14d677c7d64a@redhat.com>
         <15871468-0086-2d66-328b-0699ef6f4b31@lwfinger.net>
         <5d15c6e8-7c15-4226-c4be-d8db6ded29ef@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-06 at 08:55 +0200, Hans de Goede wrote:
> 
<snip>
> Good thank you. So what is the plan with the github version ?
> 
> Note that my submission contains a few small fixes on top of
> the github version, for which I intended to submit a pull-req
> but I've not gotten around to that yet, I've done so now:
> 
> https://github.com/hadess/rtl8723bs/pull/125
> 
> But do we want to keep maintaining the github version (for a while
> at least) I wonder, as that does mean double work?

My plan is to remove everything and point to the upstream tree as soon
as the support has landed in Linus' tree.

While there is some use in keeping it around for older kernels, we keep
getting asked to support even older kernels than reasonable, or have
users complaining about non-working machines once they use the driver,
which simply uncovers kernel bugs that were fixed upstream.

I don't think it's a good use of our time to carry on supporting this
out-of-tree. I'll however make sure to try and document the migration
in a way that's helpful to users.

Cheers
