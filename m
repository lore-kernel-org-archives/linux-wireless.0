Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55304.mail.re4.yahoo.com ([206.190.58.183]:35477 "HELO
	web55304.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752621AbZFCAzT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 20:55:19 -0400
Message-ID: <434964.30813.qm@web55304.mail.re4.yahoo.com>
Date: Tue, 2 Jun 2009 17:55:20 -0700 (PDT)
From: austinxxh-ath9k@yahoo.com
Reply-To: austinxxh-ath9k@yahoo.com
Subject: Re: [ath9k-devel] ath9k/ath5k + 80211s crash
To: Andrey Yurovsky <andrey@cozybit.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Not good, I definitely like to use 80211s with ath9k, though I'm not familiar enough to fix anything related to them yet. Say, I don't know what's the relationship between 80211s and ath9k/ath5k at this point. Trying 0602 release now and see if it improves anything. 

I was told b43 runs well with 80211s, hope ath5k/ath9k will do the same someday.

X Xiao

--- On Tue, 6/2/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:

> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Subject: Re: [ath9k-devel] ath9k/ath5k + 80211s crash
> To: "Andrey Yurovsky" <andrey@cozybit.com>
> Cc: "austinxxh-ath9k@yahoo.com" <austinxxh-ath9k@yahoo.com>, "devel@lists.open80211s.org" <devel@lists.open80211s.org>, "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> Date: Tuesday, June 2, 2009, 5:30 PM
> On Tue, Jun 02, 2009 at 09:58:59AM
> -0700, Andrey Yurovsky wrote:
> > With wireless-testing from a couple of days ago, an
> X86 system, and this patch:
> > http://osdir.com/ml/linux-wireless/2009-05/msg01241.html
> > ath9k can bring up a mesh point interface and doesn't
> crash for me,
> > but there are no mesh beacons, so mesh isn't
> working.  On ath5k, there
> > are also no beacons and mesh doesn't work, but there's
> no crash.
> 
> If no one is really interested in fixing we should just
> disable mesh
> for both ath5k and ath9k.
> 
>   Luis
> 
