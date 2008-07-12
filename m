Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:29056 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYGLQP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2008 12:15:59 -0400
Received: by wf-out-1314.google.com with SMTP id 27so4138877wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2008 09:15:57 -0700 (PDT)
Message-ID: <69e28c910807120915h505640acp36efc67fd40a4953@mail.gmail.com> (sfid-20080712_181617_744190_7F47B5C6)
Date: Sat, 12 Jul 2008 18:15:56 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: rt2x00 is still experimental?
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200807121731.57208.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215811139.30975.10.camel@dv>
	 <20080712104659.jsizw0ndw44cw4kc-cebfxv@webmail.spamcop.net>
	 <200807121713.54123.IvDoorn@gmail.com>
	 <200807121731.57208.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 12, 2008 at 5:31 PM, Michael Buesch <mb@bu3sch.de> wrote:
> I think the EXPERIMENTAL flag is just meaningless.
> You cannot run a kernel without it, as so many required and working
> subsystems and drivers depend on it.
> So I decided to drop EXPERIMENTAL for b43, as It Works (tm) for most users.
> Sure, there are a lot of corners that need fixing, but fixing them all
> up before removing EXPERIMENTAL would most likely never happen.
>
> So we removed EXPERIMENTAL from the driver when the driver worked
> for most users in STA mode. IMO that improves the overall situation,
> as it's one less EXPERIMENTAL dependency, that isn't really one.

I agree that we should reconsider what EXPERIMENTAL really means - the
whole Linux kernel is slowly becoming EXPERIMENTAL, with the original
purpose of the EXPERIMENTAL flag slowly being replaced with dependency
on external patches (see AP mode in mac80211). IMHO in general, if
something is working as most users would expect it, then it shouldn't
be EXPERIMENTAL unless there is a legacy alternative and a good reason
to suggest people to use that alternative. EXPERIMENTAL should mean
something that is not ready for the general public yet, not something
that is simply under active development.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
