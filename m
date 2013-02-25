Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:21924 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755216Ab3BYQrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:47:19 -0500
Message-ID: <dd086e962ac49f0cd3f1a255ca849de2.squirrel@www.infidigm.net> (sfid-20130225_174725_098237_17037CF9)
Date: Mon, 25 Feb 2013 12:48:27 -0500
Subject: RE: AR9374 Rev 1.3/RevB USB Linux drivers?
From: drwho@infidigm.net
To: tcc@innovelec.co.uk
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trevor,

I am moving data on the AR9374-4L3E (hw1.3) in 2.6.35 on an arm using
compat-wireless 3.8-1 up to MCS 7 rate, 40Mhz.  (I haven't figured out how
to get the MIMO to work yet - I think the AR9374 goes to MCS 15?)

Jon

>Hello Kalle
>
>We're using Ubuntu 10.04 with Kernel 2.6.32
>
>We got the open source driver from QCA via their support portal -
>ath6kl_usb_3.2.1_RC
>
>Rev B is the correct chip designation for the AR9374 silicon (that is the
>same as hw1.3) - so AR9374-BL3D is the full chip number
>
>We're getting mixed messages about support for this version in the open
>community.
>
>Thanks
>
>Trevor

