Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60158 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361Ab1EEQf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 12:35:59 -0400
Received: by mail-ew0-f51.google.com with SMTP id 6so754500ewy.38
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 09:35:57 -0700 (PDT)
Subject: Re: [PATCH 3/3] cfg80211/nl80211: add interval attribute for
 scheduled scans
From: Luciano Coelho <coelho@ti.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4DC2CEC0.2030302@candelatech.com>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-4-git-send-email-coelho@ti.com>
	 <4DC2B78E.3000205@candelatech.com>
	 <1304607108.3594.6.camel@jlt3.sipsolutions.net>
	 <4DC2B941.6@candelatech.com>
	 <1304607500.3594.7.camel@jlt3.sipsolutions.net>
	 (sfid-20110505_165557_965402_0D829BAA)  <1304607552.3594.8.camel@jlt3.sipsolutions.net>
	 <1304610524.12586.403.camel@cumari>  <1304610694.12586.404.camel@cumari>
	 <1304612001.3594.10.camel@jlt3.sipsolutions.net>
	 <4DC2CEC0.2030302@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 19:29:55 +0300
Message-ID: <1304612995.12586.409.camel@cumari> (sfid-20110505_183602_206560_009CCFB0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-05 at 09:22 -0700, Ben Greear wrote:
> On 05/05/2011 09:13 AM, Johannes Berg wrote:
> > On Thu, 2011-05-05 at 18:51 +0300, Luciano Coelho wrote:
> >> Ah, and one more thought... There's no driver implementing this at this
> >> point, so is there anything to really worry about?
> >
> > Yeah, good point, no big deal. We can keep it -- I just didn't even
> > understand why Ben thought it would not be compatible but it makes sense
> > if you just look at the patch by itself.
> 
> I was a bit confused..didn't realize it was a new command that had just
> been added.  I thought someone was adding a required member to the existing
> scan logic.
> 
> So, I have no complaints.

Okay, great.  Thanks a lot for looking into it! :)

-- 
Cheers,
Luca.

