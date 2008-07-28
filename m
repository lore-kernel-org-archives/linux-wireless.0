Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41729 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbYG1Swj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 14:52:39 -0400
Date: Mon, 28 Jul 2008 15:52:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Philip Langdale <philipl@overt.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill
Message-ID: <20080728185233.GB26564@khazad-dum.debian.net> (sfid-20080728_205305_906856_C1D1820D)
References: <488CBBAB.6010508@overt.org> <200807272259.44364.IvDoorn@gmail.com> <488CF6D8.6000700@overt.org> <20080728030437.GC10672@khazad-dum.debian.net> <1217243863.24609.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217243863.24609.6.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 28 Jul 2008, Dan Williams wrote:
> On Mon, 2008-07-28 at 00:04 -0300, Henrique de Moraes Holschuh wrote:
> > On Sun, 27 Jul 2008, Philip Langdale wrote:
> > > Ivo van Doorn wrote:
> > >> You don't seem to be using rfkill_force_state() which is required to inform the rfkill
> > >> layer about the state changes.
> > >
> > > Hmm? According to rfkill.txt, one can either use force_state() or implement the
> > > get_state() hook, and I have done the later. If this is not the correct method,
> > > can you please explain when I should be using force_state?
> > 
> > There is a bunch of rfkill bug fix patches that was not merged in
> > wireless-testing yet (which is a pity, it would be really good if they could
> > go into 2.6.27).  One of those patches fixes the docs to make it clear that
> 
> Lots of wireless people (including John) were at OLS this past week, so
> it's not entirely surprising that patch merging might have been slow.

That would explain it, yes...  Well, I sure hope this means the patches
still have a non-zero chance of being sent to mainline for 2.6.27 :-)  I am
not up to date on how merges are usually handled in the wireless and net
subsystems.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
