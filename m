Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab0LHWXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 17:23:54 -0500
Date: Wed, 8 Dec 2010 14:23:49 -0800
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rvossen@broadcom.com, dowan@broadcom.com, arend@broadcom.com
Subject: Re: [PATCH v2] linux-firmware: brcm: Removed codeversion from
 firmware filenames.
Message-ID: <20101208222349.GA31641@kroah.com>
References: <4CBE23F4.4020104@broadcom.com>
 <20101019233520.GA12510@kroah.com>
 <FD96C117992C584DBC47231B1EB6F5568206D859DC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20101020004743.GB31965@kroah.com>
 <20101020005546.GL10832@broadcom.com>
 <20101020010320.GA370@kroah.com>
 <20101021170810.GA15357@broadcom.com>
 <1288621739.26983.32.camel@macbook.infradead.org>
 <20101208205000.GA30861@broadcom.com>
 <AANLkTin70oBFYq8LMJYw6zc7oVF9-UXv=nn_ophx+L2S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTin70oBFYq8LMJYw6zc7oVF9-UXv=nn_ophx+L2S@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 08, 2010 at 11:07:53PM +0100, Rafał Miłecki wrote:
> 2010/12/8 Henry Ptasinski <henryp@broadcom.com>:
> > Second attempt at cleaning up firmware filenames.
> >
> > The basename-apiversion-codeversion construction for firmware filenames is not
> > used by most other firmware files, adds complexity, and is not providing any
> > value.  Renamed the firmware files using just basename-apiversion.  Also, fixed
> > WHENCE to have correct path to brcmfmac files.
> >
> > Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
> 
> Henry, I believe we got report that Red Hat can not include your
> firmware anyway because of licensing. Can you change license to some
> common one which allows providing your firmware with distributions?

That's news to me, what specific licensing issue have you heard about
here?  Last I saw, the issues were resolved and everyone could
redistribute this firmware.

Do you have a bugzilla number?

thanks,

greg k-h
