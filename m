Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:50197 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0CIF45 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 00:56:57 -0500
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: fix I/Q calibration (for real)
Date: Tue, 9 Mar 2010 14:56:37 +0900
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <20100308025841.7460.69949.stgit@void> <b6c5339f1003081910t745c3e5ftafbedd1298487875@mail.gmail.com> <43e72e891003081932h49340b6aia3fb6fd1e60ae8d7@mail.gmail.com>
In-Reply-To: <43e72e891003081932h49340b6aia3fb6fd1e60ae8d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003091456.37577.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 March 2010 12:32:33 Luis R. Rodriguez wrote:
> On Mon, Mar 8, 2010 at 7:10 PM, Bob Copeland <me@bobcopeland.com> wrote:
> > On Mon, Mar 8, 2010 at 8:21 PM, Luis R. Rodriguez <mcgrof@gmail.com> 
wrote:
> >> On Mon, Mar 8, 2010 at 4:50 PM, Bruno Randolf <br1@einfach.org> wrote:
> >>>> > as i said, in my point of view ath5k has several problems right now
> >>>> > (performace and stability), and i guess nobody will be using it
> >>>> > seriously in actual production use (does anyone?).
> > 
> > Yes, people do use ath5k in production.  Some large companies.
> > 
> >>>> 2.6.32 will be used by a lot of "enterprise" releases, I'd prefer
> >>>> connection stability fixes do indeed go in for 2.6.32 for ath5k
> >>> 
> >>> sure, as i said, i don't mind. :)
> >> 
> >> Alright lets skip stable for this.
> > 
> > Wow this whole line of conversation is confusing :)
> 
> Hehe. sorry well I was talking to Bruno about the "stable"
> qualifications of this fix, and it doesn't fix an oops or serious bug,
> but it certainly can improve performance but I haven't myself seen
> numbers and would hate to justify just about pushing anything
> upstream.
> 
> > If this fixes a calibration bug it needs to go to stable.
> 
> Perhaps a little more elaboration on the commit log on the impact and
> how this helps and how much would help.

ok. to stop the confusion, i'll add cc: stable.

bruno
