Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52744 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab1FJUQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 16:16:27 -0400
Date: Fri, 10 Jun 2011 16:09:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: hedwin <hedwin.koning@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
Message-ID: <20110610200900.GE2665@tuxdriver.com> (sfid-20110610_221630_688617_B7D095D2)
References: <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
 <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
 <1296633772.3624.2.camel@jlt3.sipsolutions.net>
 <20110202113052.GA14126@jm.kir.nu>
 <1296646434.5671.1.camel@jlt3.sipsolutions.net>
 <20110202133839.GA14904@jm.kir.nu>
 <AANLkTimimuho23cY7LR+HN0+VXf4Xo+i4S8EHHz3ORhK@mail.gmail.com>
 <BANLkTi=HZudtUHo1rXZEtoL7r+Lj7TBKPw@mail.gmail.com>
 <BANLkTinPxjBsFQ5n4smD4NwYHikD0kXVNw@mail.gmail.com>
 <BANLkTi=O4CSp7EyQSj0_09AE4O+5WGfvLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTi=O4CSp7EyQSj0_09AE4O+5WGfvLw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 10, 2011 at 10:07:09PM +0200, hedwin wrote:
> If it needs to be part of AOSP then it will be a problem.
> If not it entirely depends on those maintaining the specific android "distro".
> Some follow the google policy others don't.

nl80211 doesn't require libnl -- Google will simply have to implement
their own replacement.  Their apparentl (L)GPL allergy has already
led them to do so for the other system components, so why should they
stop now?

In any case, it is Google's problem to solve.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
