Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:36533 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbXLJT00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 14:26:26 -0500
Received: by py-out-1112.google.com with SMTP id u77so470669pyb
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 11:26:25 -0800 (PST)
Message-ID: <43e72e890712101126q7ba69b00sac3538a742659fbb@mail.gmail.com> (sfid-20071210_192629_056559_17CD82FA)
Date: Mon, 10 Dec 2007 14:26:24 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: lynx.abraxas@freenet.de
Subject: Re: What's wrong if wlan0 device is not reacting?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071210171521.GC1475@drago>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071206170858.GA2008@drago>
	 <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com>
	 <20071206214807.GB1811@drago>
	 <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com>
	 <8e6f94720712071121n234d9d23idaaf49d76b2fe227@mail.gmail.com>
	 <43e72e890712071336v2a4a805eu6aff9ff9c10c9418@mail.gmail.com>
	 <20071208074402.GA2508@drago> <20071210171521.GC1475@drago>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 10, 2007 12:15 PM,  <lynx.abraxas@freenet.de> wrote:
> On 08/12/07 08:44:02, lynx.abraxas@freenet.de wrote:
> > Checked  this  morning  but I'm still getting errors there. Could I be missing
> > some configuration of the build?
> >
>
> Found  the problem: I seem to have gotten a cached tarball which didn't differ
> at all. Downloading it with wget got the new one  and  that  compiles  without
> problems under 2.6.23.9. I'm sorry for the fuzz.
> Well testing the device with the new drivers will have to wait untill January.
>
>
> Till then, mary Christmas and a happy New Year.

Heh, thanks, I was about to reply that I tested the build with the
same exact kernel. Please do get back with test results :)

  Luis
