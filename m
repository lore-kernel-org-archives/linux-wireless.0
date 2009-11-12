Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:43717 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZKLTyd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:54:33 -0500
Date: Thu, 12 Nov 2009 20:54:37 +0100
From: Johannes Stezenbach <js@sig21.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: ath9k: DMA failed to stop in 10 ms
Message-ID: <20091112195437.GA11611@sig21.net>
References: <20091112152600.GA7562@sig21.net>
 <20091112181045.GA8839@sig21.net>
 <43e72e890911121013t7273c09fybff75fa2484cf07c@mail.gmail.com>
 <43e72e890911121014r13705ac0of8db341749bca528@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890911121014r13705ac0of8db341749bca528@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 10:14:06AM -0800, Luis R. Rodriguez wrote:
> On Thu, Nov 12, 2009 at 10:13 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Thu, Nov 12, 2009 at 10:10 AM, Johannes Stezenbach <js@sig21.net> wrote:
> >> On Thu, Nov 12, 2009 at 04:26:00PM +0100, Johannes Stezenbach wrote:
> >>>
> >>> When running kismet I get a lot of
> >>>
> >>> [ 2030.531809] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
> >>
> >> Update: It seems that this is only happening when kismet is hopping
> >> channels.  So it looks like an unclean shutdown of the receive
> >> process and not a real problem -- except that the log flooding is
> >> pretty annoying.
> >
> > Can you try disabling powersave before using monitor mode?
> >
> > sudo iwconfig wlan0 power off
> 
> That is, we shoudn't be sleeping during monitor mode. Curious if
> somehow we are getting to that state.

"iwconfig wlan0 power off" doesn't make a difference.


Johannes
