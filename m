Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:53522 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966370Ab2EPDI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 23:08:56 -0400
Received: by lbbgg6 with SMTP id gg6so211222lbb.8
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 20:08:53 -0700 (PDT)
Message-ID: <1337137731.4189.57.camel@cumari.coelho.fi> (sfid-20120516_050859_850941_C9B57AF4)
Subject: Re: pull request: wl12xx 2012-05-03
From: Luciano Coelho <coelho@ti.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 May 2012 06:08:51 +0300
In-Reply-To: <20120515220105.GI24572@tuxdriver.com>
References: <1336050471.12189.37.camel@cumari.coelho.fi>
	 <20120515220105.GI24572@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

On Tue, 2012-05-15 at 18:01 -0400, John W. Linville wrote:
> On Thu, May 03, 2012 at 04:07:51PM +0300, Luciano Coelho wrote:
> > Hi John,
> > 
> > This is another pull request intended for 3.5.  A few fixes here and
> > there, stuff that has been pending for a while and I hadn't had the time
> > to apply.  Nothing really major.
> > 
> > Please pull or let me know if there's any problem. This tree is based on
> > wireless-next/master and the head I want you to pull from is
> > 422823e85d3957b64c573a2f15c6172d78de1e00. 
> > 
> > Thanks! 
> > 
> > The following changes since commit 0a9b3782ef402d27c3e6d1b116f10076a9dd088c:
> > 
> >   {nl,cfg,mac}80211: Allow user to see/configure HT protection mode (2012-05-02 14:30:55 -0400)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville
> > 
> > for you to fetch changes up to 422823e85d3957b64c573a2f15c6172d78de1e00:
> > 
> >   wlcore/wl12xx: implement better beacon loss handling (2012-05-03 15:45:03 +0300)
> 
> I used the magic of git to fix this up after last week's rebasing.
> Please do take the opportunity to verify the result.

Your magic skills still seem to be working very well. ;)

The only difference I found in our code from my original pull request
branch and your new wireless-next/master was Dave's commit 9d83ba4b
wl12xx: Stop using NLA_PUT*().

Thanks!

-- 
Cheers,
Luca.

