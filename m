Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54571 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3DRNuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 09:50:11 -0400
Received: by mail-ee0-f46.google.com with SMTP id d49so1324813eek.33
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 06:50:10 -0700 (PDT)
Date: Thu, 18 Apr 2013 15:46:02 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v2 2/2] mac80211: minstrel_ht: initialize rates selection
Message-ID: <20130418134602.GF8638@magnum.frso.rivierawaves.com> (sfid-20130418_155016_517333_AD2E4E0D)
References: <1366287981-24134-1-git-send-email-karl.beldan@gmail.com>
 <1366287981-24134-2-git-send-email-karl.beldan@gmail.com>
 <20130418124050.GD8638@magnum.frso.rivierawaves.com>
 <1366292199.8336.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366292199.8336.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 18, 2013 at 03:36:39PM +0200, Johannes Berg wrote:
> On Thu, 2013-04-18 at 14:40 +0200, Karl Beldan wrote:
> > Johannes, Felix,
> > 
> > This seems to me like an important enough issue to IMHO, make it into
> > 3.9/-stable. But since we only have a few days before Linus tags the 3.9
> > I understand the boldness of the thought.
> 
> I'm not going to try for 3.9, it wouldn't happen anyway, but if you want
> to tag them as Cc stable it's your call. I'm not familiar enough with
> the code to really be able to judge the impact I guess. It seems
> unlikely to me though that some device would support MCS 1 but not MCS
> 0, or MCS 9 but not 8, etc.?
> 
I imagined devices that would have their -supported MCSes configure their
hw- that for any reason would not "handle" other ones.
I don't know why I deemed it that important, and agree with you and
Felix ;)

 
Karl
