Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49447 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab1FJUZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 16:25:18 -0400
Received: by iwn34 with SMTP id 34so2449416iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 13:25:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110610200900.GE2665@tuxdriver.com>
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
	<20110610200900.GE2665@tuxdriver.com>
Date: Fri, 10 Jun 2011 22:25:17 +0200
Message-ID: <BANLkTimnDDhqD4D+xoKwfETz=szgOTAK7w@mail.gmail.com> (sfid-20110610_222523_649422_ED2547EE)
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
From: hedwin <hedwin.koning@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If I want to use wpa_supplicant it seems that I need to use libnl. If
not how does wpa_supplicant connect to mac80211?

Well if it is google's problem to solve it, this discussion about
wireless support in android is on hold until they've done so. right?

Hedwin


On Fri, Jun 10, 2011 at 10:09 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Jun 10, 2011 at 10:07:09PM +0200, hedwin wrote:
>> If it needs to be part of AOSP then it will be a problem.
>> If not it entirely depends on those maintaining the specific android "distro".
>> Some follow the google policy others don't.
>
> nl80211 doesn't require libnl -- Google will simply have to implement
> their own replacement.  Their apparentl (L)GPL allergy has already
> led them to do so for the other system components, so why should they
> stop now?
>
> In any case, it is Google's problem to solve.
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
