Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1717 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0LHXfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 18:35:36 -0500
Date: Wed, 8 Dec 2010 15:35:27 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Greg KH" <greg@kroah.com>
cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"David Woodhouse" <dwmw2@infradead.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>, dcbw@redhat.com
Subject: Re: [PATCH v2] linux-firmware: brcm: Removed codeversion from
 firmware filenames.
Message-ID: <20101208233527.GA2148@broadcom.com>
References: <20101019233520.GA12510@kroah.com>
 <FD96C117992C584DBC47231B1EB6F5568206D859DC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20101020004743.GB31965@kroah.com>
 <20101020005546.GL10832@broadcom.com> <20101020010320.GA370@kroah.com>
 <20101021170810.GA15357@broadcom.com>
 <1288621739.26983.32.camel@macbook.infradead.org>
 <20101208205000.GA30861@broadcom.com>
 <AANLkTin70oBFYq8LMJYw6zc7oVF9-UXv=nn_ophx+L2S@mail.gmail.com>
 <20101208222349.GA31641@kroah.com>
MIME-Version: 1.0
In-Reply-To: <20101208222349.GA31641@kroah.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 08, 2010 at 02:23:49PM -0800, Greg KH wrote:
> On Wed, Dec 08, 2010 at 11:07:53PM +0100, Rafał Miłecki wrote:
> > 2010/12/8 Henry Ptasinski <henryp@broadcom.com>:
> > > Second attempt at cleaning up firmware filenames.
> > >
> > > The basename-apiversion-codeversion construction for firmware filenames is not
> > > used by most other firmware files, adds complexity, and is not providing any
> > > value.  Renamed the firmware files using just basename-apiversion.  Also, fixed
> > > WHENCE to have correct path to brcmfmac files.
> > >
> > > Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
> > 
> > Henry, I believe we got report that Red Hat can not include your
> > firmware anyway because of licensing. Can you change license to some
> > common one which allows providing your firmware with distributions?
> 
> That's news to me, what specific licensing issue have you heard about
> here?  Last I saw, the issues were resolved and everyone could
> redistribute this firmware.

On a thread about other firmware, Dan Williams wrote:

> There's an existing Broadcom license in linux-firmware.git, and it *may*
> be OK, but it's really, really long and given that other major companies
> adopted the "shorter is better" approach, it's hard to believe that all
> the existing Broadcom license text is actually needed.

I'm not sure that translates to "can not include your firmware". Regardless, I
am trying to get our license simplified.  Obviously that's taking some time,
and I don't have any resolution yet, but I'll keep working on it.

- Henry


