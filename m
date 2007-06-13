Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3501 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667AbXFMOyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 10:54:38 -0400
Date: Wed, 13 Jun 2007 10:31:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andy Green <andy@warmcat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH Try#10 4/4] mac80211: Monitor mode radiotap-based packet injection
Message-ID: <20070613143152.GC5576@tuxdriver.com>
References: <20070612095551.323709697@warmcat.com> <20070612095658.362328798@warmcat.com> <200706122254.43782.flamingice@sourmilk.net> <20070613130020.GB5576@tuxdriver.com> <466FFA99.90003@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <466FFA99.90003@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2007 at 03:09:29PM +0100, Andy Green wrote:
> John W. Linville wrote:
> > On Tue, Jun 12, 2007 at 10:54:38PM -0700, Michael Wu wrote:
> > 
> >> These patches should be pretty good now. I suggest CCing John Linville, 
> >> Johannes Berg, and Jiri Benc on the next series. I'd like to get these 
> >> patches in soon if there are no other issues. 12 tries should be enough to 
> >> get this right. ;)
> > 
> > Amen. :-)
> 
> *shrug*  Y'all welcome.  The main thing I'll take away though is the two
> solid months (out of three since the first patch) of complete silence.

Well, sorry about that...but in that time we've had a 2.6.21 merge
window fire drill for mac80211, a bunch of libertas patches, a tough
review of rtl8187, and arguments/reviews/discussions about .11n
support, .11e/WMM support, hardware scanning support, etc.  Also,
it was end of term for a number of contributors who are full-time
students, and it was crunch time for the release of Fedora 7 (which
has a lot more wireless stuff in it than any previous Fedora release).

In the end, you did the right thing: keep posting the patches until
they get the proper attentions.  Thanks for persevering!

John
-- 
John W. Linville
linville@tuxdriver.com
