Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55011 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbZJBPCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 11:02:34 -0400
Date: Fri, 2 Oct 2009 17:02:34 +0200
To: Greg KH <gregkh@suse.de>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattia Dongili <malattia@linux.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: sony-laptop: check for rfkill hard block at load time
Message-ID: <20091002150234.GI6268@gamma.logic.tuwien.ac.at>
References: <20091002100029.GC4406@gandalf.dynalias.org> <20091002143800.GC21025@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091002143800.GC21025@suse.de>
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fr, 02 Okt 2009, Greg KH wrote:
> On Fri, Oct 02, 2009 at 07:00:29PM +0900, Norbert Preining wrote:
> > On Thu, 24 Sep 2009, Alan Jenkins wrote:
> > > We can fix this by querying the firmware at load time and calling
> > > rfkill_set_hw_state().
> > 
> > The bug concerning checking the state after suspend to ram should probably
> > be also queued. Original email attached.
> 
> Queued for what?

Queued for inclusion into 2.6.3N (for N>=2), that is what the original email
was stating. Sorry if I stripped it down to far.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
HIBBING (n.)
The marks left on the outside breast pocket of a storekeeper's overall
where he has put away his pen and missed.
			--- Douglas Adams, The Meaning of Liff
