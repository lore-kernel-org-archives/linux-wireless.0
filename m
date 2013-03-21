Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout1.wanadoo.co.uk ([80.12.242.29]:37703 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab3CUNe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 09:34:59 -0400
Date: Thu, 21 Mar 2013 14:34:56 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <3255301.1161363872896882.JavaMail.www@wwinf3715> (sfid-20130321_143519_131720_9A8AFE27)
In-Reply-To: <CAD2nsn1ep2HOZx55rGmbpgof-HWkMMeiEHSGBEqpe0gZzubbWg@mail.gmail.com>
Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

What do you need to me to do on this?
I see that function in the wmi.c file.

Do you want me to add some debug printk's in there somewhere?

Regards

Nick

> Message Received: Mar 21 2013, 11:42 AM
> From: "Mohammed Shafi"
> To: nick@nhthomas.freeserve.co.uk
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
>
> On Wed, Mar 20, 2013 at 10:33 PM, wrote:
> >
> > Here is another example, taken from Wireshark.
> > It's an ARP response, effectively saying IP address 192.168.0.107 is at 00:03:7f:20:50:59
> >
> > This is a message coming out of the wifi adaptor, and the above numbers are the IP address, and MAC address of the wifi device.
> >
> > 7f 20 50 59 00 24 00 03 7f 20 50 59 08 06 00 01
> > 08 00 06 04 00 02 00 03 7f 20 50 59 c0 a8 00 07
> > 20 cf 30 94 83 7b c0 a8 00 65
> >
> > What we see here is the Destination MAC address is 7f:20:50:59:00:24 (first 6 bytes).
> > But that's wrong. It should be 20:cf:30:94:83:7b .
> >
> > The other parts look right though:
> > 00:03:7f:20:50:59 is the MAC of the wifi device.
> > c0 a8 00 65 is 192.168.0.101 which is the IP address of the destination.
> > c0 a8 00 07 is the IP address of the wifi adaptor itself.
>
> let us check in ath6kl_wmi_dix_2_dot3, that should give us some clue.
>
> >
> > So, where in the code is the first 6 bytes generated ?
> >
> >
> > Regards
> >
> > Nick
>
>
>
> --
> thanks,
> shafi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

