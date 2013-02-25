Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.smtp.dk ([93.90.117.178]:56783 "EHLO smtp.dk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758717Ab3BYPCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 10:02:55 -0500
From: "Trevor Cullen" <tcc@innovelec.co.uk>
To: "'Kalle Valo'" <kvalo@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: RE: AR9374 Rev 1.3/RevB USB Linux drivers?
Date: Mon, 25 Feb 2013 15:07:36 -0000
Message-ID: <00d301ce1369$d9ec9f20$8dc5dd60$@innovelec.co.uk> (sfid-20130225_160259_753743_8C74BD7A)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle

We're using Ubuntu 10.04 with Kernel 2.6.32

We got the open source driver from QCA via their support portal -
ath6kl_usb_3.2.1_RC

Rev B is the correct chip designation for the AR9374 silicon (that is the
same as hw1.3) - so AR9374-BL3D is the full chip number

We're getting mixed messages about support for this version in the open
community.

Thanks

Trevor

 
Trevor Cullen BSc (Hons) MIoD
Managing Director
tcc@innovelec.co.uk
www.innovelec.co.uk

Innovelec Solutions Limited 
Maylands Business Centre, Redbourn Rd,
Hemel Hempstead, Herts, HP2 7ES.
Tel: +44 (0) 1442 573035
DDI: +44 (0) 1442 573039
Mobile: +44 (0) 7785 575840 
Registration No. 06879179
VAT Registration No. GB 973 2106 29

This e-mail transmission is intended solely for the person or organisation
to whom it is addressed. It may contain confidential and privileged
information.
If you are not the intended recipient, you must not copy, distribute or
disseminate the information, or take any action in reliance of it.
If you have received this message in error, do not open any attachment but
please notify the sender deleting this message from your system.

This e-mail may contain personal views which are not those of Innovelec
Solutions Limited unless specifically stated.

Internet e-mails are not necessarily secure, Innovelec Solutions Limited
does not accept responsibility for any changes made to this message after it
was sent.

Whilst all reasonable care has been taken to ensure that this e-mail and any
attachments are virus free, no responsibility is accepted by Innovelec
Solutions Limited in this regard.
We advise that in keeping with good computing practice the recipient should
ensure they are actually virus free.

-----Original Message-----
From: Kalle Valo [mailto:kvalo@qca.qualcomm.com] 
Sent: 25 February 2013 14:27
To: Trevor Cullen
Cc: linux-wireless@vger.kernel.org; ath6kl-devel@qca.qualcomm.com
Subject: Re: AR9374 Rev 1.3/RevB USB Linux drivers?

Trevor Cullen <tcc@innovelec.co.uk> writes:

> We are trying to install drivers for AR9374 USB with Rev1.3/Rev B 
> silicon but have been told the current driver only supports Rev1.1/Rev A
silicon.
>
> What is the issue? When will the driver be bumped to worked with the 
> new silicon?

What ath6kl version are you using exactly? From kernel or from
compat-wireless? Where did you get it? What is your kernel version?

The latest version of ath6kl does support ar6004 hw1.3.

What's RevB? I haven't seen that before.

--
Kalle Valo

