Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4235 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab0LIBaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 20:30:23 -0500
Date: Wed, 8 Dec 2010 17:30:03 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Greg KH" <greg@kroah.com>,
	"David Woodhouse" <dwmw2@infradead.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"dcbw@redhat.com" <dcbw@redhat.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] linux-firmware: brcm: Removed codeversion from
 firmware filenames.
Message-ID: <20101209013003.GB2243@broadcom.com>
References: <20101020004743.GB31965@kroah.com>
 <20101020005546.GL10832@broadcom.com> <20101020010320.GA370@kroah.com>
 <20101021170810.GA15357@broadcom.com>
 <1288621739.26983.32.camel@macbook.infradead.org>
 <20101208205000.GA30861@broadcom.com>
 <AANLkTin70oBFYq8LMJYw6zc7oVF9-UXv=nn_ophx+L2S@mail.gmail.com>
 <20101208222349.GA31641@kroah.com> <20101208233527.GA2148@broadcom.com>
 <AANLkTimXjLCLwznMDzT-KdX1qfHvdbpNpJPcNpmuZkOS@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <AANLkTimXjLCLwznMDzT-KdX1qfHvdbpNpJPcNpmuZkOS@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 08, 2010 at 04:28:31PM -0800, Rafał Miłecki wrote:
> 2010/12/9 Henry Ptasinski <henryp@broadcom.com>:
> > On Wed, Dec 08, 2010 at 02:23:49PM -0800, Greg KH wrote:
> >> On Wed, Dec 08, 2010 at 11:07:53PM +0100, Rafał Miłecki wrote:
> >> > 2010/12/8 Henry Ptasinski <henryp@broadcom.com>:
> >> > > Second attempt at cleaning up firmware filenames.
> >> > >
> >> > > The basename-apiversion-codeversion construction for firmware filenames is not
> >> > > used by most other firmware files, adds complexity, and is not providing any
> >> > > value.  Renamed the firmware files using just basename-apiversion.  Also, fixed
> >> > > WHENCE to have correct path to brcmfmac files.
> >> > >
> >> > > Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
> >> >
> >> > Henry, I believe we got report that Red Hat can not include your
> >> > firmware anyway because of licensing. Can you change license to some
> >> > common one which allows providing your firmware with distributions?
> >>
> >> That's news to me, what specific licensing issue have you heard about
> >> here?  Last I saw, the issues were resolved and everyone could
> >> redistribute this firmware.
> >
> > On a thread about other firmware, Dan Williams wrote:
> >
> >> There's an existing Broadcom license in linux-firmware.git, and it *may*
> >> be OK, but it's really, really long and given that other major companies
> >> adopted the "shorter is better" approach, it's hard to believe that all
> >> the existing Broadcom license text is actually needed.
> >
> > I'm not sure that translates to "can not include your firmware". Regardless, I
> > am trying to get our license simplified.  Obviously that's taking some time,
> > and I don't have any resolution yet, but I'll keep working on it.
> 
> You quoted just a selected part of Dan's message. Earlier he mentioned
> about Fedora's problems (sorry, I misremembered distro)

Yes, I omitted the earlier part since those comments were not directly about
the existing Broadcom license.   But to be complete:

> That's not enough to allow Fedora to ship it.  We'd need a clear license from
> Broadcom (ex the existing Intel or Marvell firmware licenses) before Fedora
> could feel comfortable about shipping it legally in all jurisdictions.
> 
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=LICENCE.mwl8k;h=3224e1bbfba8ccd1d980f57eb88378f20bb2d146;hb=HEAD
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=LICENCE.libertas;h=1fd8766c26a170b50605455ae6f54b607baa12cf;hb=HEAD
>
> There's an existing Broadcom license in linux-firmware.git, and it *may* be
> OK, but it's really, really long and given that other major companies adopted
> the "shorter is better" approach, it's hard to believe that all the existing
> Broadcom license text is actually needed.

(via http://marc.info/?l=linux-wireless&m=128767431028798&w=2)


- Henry

