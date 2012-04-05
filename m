Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41020 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab2DEWtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 18:49:14 -0400
Date: Thu, 5 Apr 2012 15:49:12 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	jerome huang <jerome.syno@gmail.com>,
	"Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: rt8192cu on USB3
Message-ID: <20120405224912.GE6194@xanatos> (sfid-20120406_004931_549785_815B8A29)
References: <CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com>
 <CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com>
 <4F58F2D0.5060805@lwfinger.net>
 <CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com>
 <4F59800B.80407@lwfinger.net>
 <20120322223107.GA8877@xanatos>
 <4F6BDEDF.2020907@lwfinger.net>
 <20120323203404.GD5207@xanatos>
 <4F6D2E76.90204@gmail.com>
 <4F6D5494.3000001@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F6D5494.3000001@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping.  Richard, have you had a chance to see if 3.4-rc1 fixes your
issues with rtl8192cu?

Sarah Sharp

On Fri, Mar 23, 2012 at 11:59:00PM -0500, Larry Finger wrote:
> On 03/23/2012 09:16 PM, Richard Farina wrote:
> 
> >Given that I can replicate this issue using several different drivers,
> >should I test using 3.4_rc1 kernel to see if the usb is fixed or using
> >compat-wireless based on 3.4_rc1 to see if the drivers are fixed? Or both?
> 
> You should test 3.4-rc1 first. According to what Sarah wrote, that
> should fix many of the problems. If rtl8192cu still has the problem
> then, I have a potential fix. At the moment, there is nothing in
> compat-wireless to help this problem.
> 
> Larry
