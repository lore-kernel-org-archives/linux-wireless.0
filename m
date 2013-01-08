Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917Ab3AHIrx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 03:47:53 -0500
Date: Tue, 8 Jan 2013 09:47:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20130108084744.GA17899@redhat.com> (sfid-20130108_094756_427997_0EF2BCB0)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <CAJZjf_z71tqE5pdiJtUXpuPj1eCRRF+EdygZb_zQLnem5izxwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_z71tqE5pdiJtUXpuPj1eCRRF+EdygZb_zQLnem5izxwA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 08, 2013 at 01:48:01AM +0000, Pedro Francisco wrote:
> On Mon, Jan 7, 2013 at 11:08 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > Hi
> >
> > On Wed, Dec 26, 2012 at 07:54:25PM +0100, Tino Keitel wrote:
> >>
> >> Hi Stanislaw,
> >>
> >> is there any progress regarding this? If not, I could try to implement
> >> it in the current kernel.  However, I don't have any knowlegde about
> >> hardware related features.  If you have, maybe I could use your
> >> knowledge to do it myself.
> >
> > I posted patch here
> > http://marc.info/?l=linux-wireless&m=135601033021616&w=2
> >
> > But I did not review code regarding power save to catch possible
> > problems. Testing are bug reporting are welcome ...
> 
> Is the firmware crashing only after suspend? Or 'always'? (iwl3945)

I don't have 3945 crashes on my local machine when I enable PS. The only
documented issue on 3945 I found is this bug:
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2125
It stands that problem happen just after associate.

BTW: PS is still disabled by default, to test it need to be enabled by
iw or iwconfig tool.

Stanislaw
