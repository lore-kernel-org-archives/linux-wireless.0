Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2EZRRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 13:17:33 -0400
Date: Sat, 26 May 2012 12:17:28 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 0/8] brcm80211: smac: rework regulatory support
Message-ID: <20120526171728.GA11759@ubuntu-mba> (sfid-20120526_191736_828688_9DC60362)
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <4FC00848.9060901@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC00848.9060901@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 26, 2012 at 12:31:36AM +0200, Arend van Spriel wrote:
> On 04/16/2012 10:17 PM, Seth Forshee wrote:
> > Hi Arnd,
> 
> You missed an 'e' ;-)

Oops! My apologies :)

> > Here's the latest update to the brcmsmac regulatory rework that I've
> > been working on. I've broken it up into a series of smaller patches,
> > cleaned things up, and finished what changes I can with the information
> > available to me.
> 
> It took a while. There were some discussions and we agreed that your
> changes establish a better integration with the regulatory framework.
> There are some concerns about the content of the crda database, but that
> is another thing outside the scope of your patches.

Great!

> > I've attempted to maintain the same high-level behavior that the
> > brcmsmac internal regulatory support currently enforces.
> 
> Appreciated. We can add/change in subsequent patches. I collected review
> comments internally including mine. I will provide them in response to
> each individual patch.

I've looked over the comments, and I agree with most of them. I'll
respond to each individually.

> General comment: you should run 'checkpatch.pl --strict' script over the
> patches. I came across several issues that will probably be flagged by it.

Yeah, I didn't bother with it for the RFC patches since I just wanted to
ensure that I had buy-in from you guys on the changes in general. I've
already got a few things cleaned up locally, and I'll run everything
through checkpatch before I send them again.

Thanks,
Seth

