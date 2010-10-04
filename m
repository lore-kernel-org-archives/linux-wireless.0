Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0JDSgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:36:21 -0400
Received: by bwz11 with SMTP id 11so3856705bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 11:36:20 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: lockdep warning in ieee80211 rx path
Date: Mon, 4 Oct 2010 20:36:12 +0200
Cc: Ming Lei <tom.leiming@gmail.com>, linux-wireless@vger.kernel.org
References: <AANLkTin5KfmQLYxLWdhTcO-AM0t83dVq=LFCG0UGysaw@mail.gmail.com> <201010042000.44518.chunkeey@googlemail.com> <4CAA17FA.3080403@candelatech.com>
In-Reply-To: <4CAA17FA.3080403@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010042036.12542.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 October 2010 20:07:54 Ben Greear wrote:
> On 10/04/2010 11:00 AM, Christian Lamparter wrote:
> > On Monday 04 October 2010 19:52:12 Ben Greear wrote:
> >> On 09/14/2010 01:51 PM, Christian Lamparter wrote:
> >>> On Sunday 05 September 2010 11:32:26 Ming Lei wrote:
> >>>> Seems the warning does not affect use of wireless,  false positive?
> >>>
> >>> No, it's a bug... but please read&   test the attached patch.
> >>
> >> This is not yet in wireless-testing.  Should it be?
> > have you heard anything from Ming Lei about this subject?
> > Or have you reproduced the bug too?
> 
> See my post about   inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W}.
> 
> I'm not sure it's the same bug, but it would appear similar at least.
At first glance, your trace looks unrelated to Ming Lei's issue.
But we won't know for sure, unless you have a reliable way to
reproduce the exact circumstances.
 
> If your patch is probably good, I can go ahead and apply it.
> We can at least test that it doesn't obviously make things worse.
Ok, if the patch doesn't make things worse than they are, I can
risk another attempt.

Best regards,
	Chr
