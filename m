Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161110Ab3FTTyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 15:54:04 -0400
Date: Thu, 20 Jun 2013 12:54:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: stable@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] brcmfmac: Turn off ARP offloading when configured for AP.
Message-ID: <20130620195403.GA18617@kroah.com> (sfid-20130620_215409_787636_21E69962)
References: <1370508957-12709-1-git-send-email-arend@broadcom.com>
 <51C15D4D.6040009@broadcom.com>
 <20130619141920.GB7395@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130619141920.GB7395@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 07:19:20AM -0700, Greg KH wrote:
> On Wed, Jun 19, 2013 at 09:27:09AM +0200, Arend van Spriel wrote:
> > On 06/06/2013 10:55 AM, Arend van Spriel wrote:
> > >From: Hante Meuleman <meuleman@broadcom.com>
> > 
> > Hi Greg,
> > 
> > I noticed your review announcement for v3.9.7 and did not see the
> > change below. I sent it to stable because the original upstream
> > commit did not apply. Did I miss some step in the process?
> 
> Ah, somehow I missed your patch, sorry about that, I do have it in my
> mbox.  What kernel tree(s) do you want it to be applied to?  I'll pick
> it up in my next round of releases.

Now applied, sorry for the delay.

greg k-h
