Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42900 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1CPOqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:46:00 -0400
Date: Wed, 16 Mar 2011 10:33:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Peter Lemenkov <lemenkov@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@redhat.com>,
	rt2x00-dev <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 1/4] rt2x00: Add rt2870 device id
Message-ID: <20110316143350.GA7727@tuxdriver.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
 <1300284739-7797-2-git-send-email-lemenkov@gmail.com>
 <AANLkTima9_VSL4Db1RXSPLRXyoBOwdym9CkJUJrySnSC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTima9_VSL4Db1RXSPLRXyoBOwdym9CkJUJrySnSC@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 03:28:04PM +0100, Rafał Miłecki wrote:
> 2011/3/16 Peter Lemenkov <lemenkov@gmail.com>:
> > Add ID for Asus USB-N11 Wi-FI adapter. Tested by me.
> >
> > Signed-off-by: Peter Lemenkov <lemenkov@gmail.com>
> > ---
> >  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> > index 197a36c..03a5308 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> > @@ -719,6 +719,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
> >        { USB_DEVICE(0x0b05, 0x1732), USB_DEVICE_DATA(&rt2800usb_ops) },
> >        { USB_DEVICE(0x0b05, 0x1742), USB_DEVICE_DATA(&rt2800usb_ops) },
> >        { USB_DEVICE(0x0b05, 0x1784), USB_DEVICE_DATA(&rt2800usb_ops) },
> > +       { USB_DEVICE(0x1761, 0x0b05), USB_DEVICE_DATA(&rt2800usb_ops) },
> >        /* AzureWave */
> >        { USB_DEVICE(0x13d3, 0x3247), USB_DEVICE_DATA(&rt2800usb_ops) },
> >        { USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
> > @@ -913,7 +914,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
> >        { USB_DEVICE(0x0b05, 0x1760), USB_DEVICE_DATA(&rt2800usb_ops) },
> >        { USB_DEVICE(0x0b05, 0x1761), USB_DEVICE_DATA(&rt2800usb_ops) },
> >        { USB_DEVICE(0x0b05, 0x1790), USB_DEVICE_DATA(&rt2800usb_ops) },
> > -       { USB_DEVICE(0x1761, 0x0b05), USB_DEVICE_DATA(&rt2800usb_ops) },
> >        /* AzureWave */
> >        { USB_DEVICE(0x13d3, 0x3262), USB_DEVICE_DATA(&rt2800usb_ops) },
> >        { USB_DEVICE(0x13d3, 0x3284), USB_DEVICE_DATA(&rt2800usb_ops) },
> 
> Either: the patch or title seems to be incorrect. It looks like you
> just moved place where entry was typed...?

He moved it out of the UNKNOWN block.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
