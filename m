Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34238 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752695AbcLQVTp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 16:19:45 -0500
Received: by mail-yw0-f169.google.com with SMTP id t125so48511221ywc.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2016 13:19:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161216203538.GA12608@animalcreek.com>
References: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
 <20160422000119.GA21754@animalcreek.com> <20161213220545.GA29317@animalcreek.com>
 <CAO7Z3WJwf80mCqubSYTeK=BHN9sd=mzmL9th4Su-E25de6TmAg@mail.gmail.com>
 <20161214155743.GA22282@animalcreek.com> <CAO7Z3WKqhS5Q6qAaDs8364KP5-7ma=b_ic2B10=njngMmp5noQ@mail.gmail.com>
 <20161214171010.GA29321@animalcreek.com> <CAO7Z3WLpp0YVxXxo6M11PMPu+5OaA1fRhNQNoPJ-b4LRCPrLAg@mail.gmail.com>
 <20161214223123.GA10281@animalcreek.com> <20161216045210.GA29196@animalcreek.com>
 <20161216203538.GA12608@animalcreek.com>
From: Geoff Lansberry <geoff@kuvee.com>
Date: Sat, 17 Dec 2016 16:19:04 -0500
Message-ID: <CAO7Z3W+grhLnP05bPShheuvSet08CoYhFStDpDVgztf=Wz42Fw@mail.gmail.com> (sfid-20161217_221950_944234_5EAF835B)
Subject: Re: [Patch] NFC: trf7970a:
To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Justin Bronder <justin@kuvee.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark,   from our consultant:

It isn't important whether the flood script is successful in writing
or not. The point of it is to force a segfault by making many
requests. It needs to run for several hundred iterations (successful
or not) in order to generate the segfault.

Geoff
Geoff Lansberry


Engineering Guy
Kuv=C3=A9e, Inc
125 Kingston St., 3rd Floor
Boston, MA 02111
1-617-290-1118 (m)
geoff.lansberry (skype)
http://www.kuvee.com



On Fri, Dec 16, 2016 at 3:35 PM, Mark Greer <mgreer@animalcreek.com> wrote:
> On Thu, Dec 15, 2016 at 09:52:10PM -0700, Mark Greer wrote:
>> On Wed, Dec 14, 2016 at 03:31:23PM -0700, Mark Greer wrote:
>> > I'll start on this
>> > tonight but won't likely get far until tomorrow.  In the meantime,
>> > if you and/or your contractor make progress, please share.
>>
>> Geoff,
>>
>> Which version of neard are you using?  0.16?
>
> Also, the flood.py script doesn't work well at all for me.  At best,
> it works successfully for one iteration and then fails continually for
> all other iterations.  This is true when using the trf7970a and pn533
> drivers.
>
> I've tweaked it a but but still no success.  I haven't looked all that
> closely at it but since you said you were persuing this, I'll wait to
> hear more from you.
>
> Mark
> --
