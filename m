Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbYAGU57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 15:57:59 -0500
Subject: Re: VT6656 driver source available from VIA
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Forest Bond <forest@alittletooquiet.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890801071247w4f25de53v1b5f09828fcb840c@mail.gmail.com>
References: <20070919193743.GA14127@storm.local.network>
	 <20071101185900.GD14943@tuxdriver.com>
	 <20071101190711.GB17825@storm.local.network>
	 <20071101191250.GE14943@tuxdriver.com>
	 <20071105020730.GA4414@storm.local.network>
	 <20071114170051.GD23778@storm.local.network>
	 <20071114170634.GC6226@tuxdriver.com>
	 <20080107184949.GI18550@storm.local.network>
	 <43e72e890801071220r33401a6cg30a0bf4fc391b452@mail.gmail.com>
	 <20080107203101.GA4599@storm.local.network>
	 <43e72e890801071247w4f25de53v1b5f09828fcb840c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 15:54:56 -0500
Message-Id: <1199739296.21366.1.camel@localhost.localdomain> (sfid-20080107_205801_333295_85CC09EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-01-07 at 15:47 -0500, Luis R. Rodriguez wrote:
> On Jan 7, 2008 3:31 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> >
> > On Mon, Jan 07, 2008 at 03:20:02PM -0500, Luis R. Rodriguez wrote:
> > > On Jan 7, 2008 1:49 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> > > > Hi,
> > > >
> > > > On Wed, Nov 14, 2007 at 12:06:34PM -0500, John W. Linville wrote:
> > > > > On Wed, Nov 14, 2007 at 12:00:51PM -0500, Forest Bond wrote:
> > > > >> On Sun, Nov 04, 2007 at 09:07:31PM -0500, Forest Bond wrote:
> > > > >>> The post is here:
> > > > >>>
> > > > >>> http://forums.viaarena.com/messageview.aspx?catid=28&threadid=78745
> > > > >>>
> > > > >>> Any noise that can be contributed is welcome and appreciated.  You'll need
> > > > >>> to create an account to post, though.
> > > > >
> > > > >> I also added these.  Perhaps having plenty of content/links regarding this
> > > > >> issue will help to increase visibility:
> > > > >>
> > > > >> http://www.alittletooquiet.net/text/a-license-for-the-via-vt6656-linux-driver/
> > > > >> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/162671
> > > > >
> > > > > Excellent...I appreciate your efforts as an agitator! :-)
> > > >
> > > > At this point I am not anticipating positive results WRT this endeavor, and am
> > > > unable to pursue further assistance from VIA.  Further, I've seen that the
> > > > driver in question likely exhibits some interesting quirks that makes it
> > > > difficult to use.  It is also bit-rotting out of relevance.
> > >
> > > This is unfortunate to hear...
> > >
> > > > Can the driver be used as a reference for a fresh implementation?  I've not
> > > > written a driver before, but would be open to the possibility.
> > >
> > > IANAL but I believe It basically depends on the license the vendor
> > > issued the driver under and its sources under. If no license was used
> > > then I believe the standard copyright license terms should be assumed.
> > > What license was used throughout the driver files?
> > >
> > > > What are the legal ramifications of a driver author having access to
> > > > proprietary source code?
> > >
> > > Again, I believe it depends on the license/NDA/terms under which the
> > > driver author obtained access to such proprietary source code. The
> > > more details you provide the better.
> >
> > The license was omitted.  This was presumably an oversight, but intentions are
> > always hard to know when the other party isn't saying anything :)
> 
> I'm calling their offices now, we should be able to just talk to
> someone from their dev team...
> 
> > There's little doubt in my mind that we get nothing more than fair use out of
> > this package, though.  The question is "is that enough?".  Code copying is
> > obviously not allowed, but is a new (and sufficiently different) implementation
> > allowed?
> 
> I think so but IANAL so not too sure, we can then ask SFLC to verify
> in the end what's possible or not.

That would be good; the issue is that there is _no_ license at all with
the code, but that the code contains MODULE_LICENSE("GPL") as the sole
indicator of license intent, if you can even interpret that as license
intent.  There isn't really any copyright indication anywhere in the
sources either ISTR.  Maybe query the SFLC about what is possible given
these limitations?

Dan


