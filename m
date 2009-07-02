Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:19882 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbZGBPJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 11:09:05 -0400
Subject: Re: [PATCH hostap/wpa_supplicant] Allow wpa_supplicant to use
 libnl-2.0
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: Dan Williams <dcbw@redhat.com>
Cc: jouni.malinen@atheros.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246537755.16543.1.camel@localhost.localdomain>
References: <1246481949.11632.36.camel@jdl-desktop>
	 <1246537755.16543.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 10:09:08 -0500
Message-Id: <1246547348.15196.8.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-02 at 08:29 -0400, Dan Williams wrote:
> On Wed, 2009-07-01 at 15:59 -0500, Jon Loeliger wrote:
> > Introduce CONFIG_LIBNL20 .config parameter and propogate
> > that as a CFLAG in the Makefile.
> > 
> > Add forward-compatibility code to allow the existing code
> > to also use libnl-2.0.
> > 
> > Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>
> 
> You might actually want to post this to the hostap/wpa_supplicant
> mailing list instead.  While developers involved in both projects are
> subscribed to both lists, linux-wireless isn't the right place for
> patches against hostap and wpa_supplicant.
> 
> http://lists.shmoo.com/mailman/listinfo/hostap
> 
> Dan

Argh.  Done.  Thanks.

jdl


