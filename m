Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:52069 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbYILDHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 23:07:34 -0400
Message-ID: <48C9DCF4.7000604@lwfinger.net> (sfid-20080912_050738_427232_B9762386)
Date: Thu, 11 Sep 2008 22:07:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Steven Noonan <steven@uplinklabs.net>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: I need help with a sparse warning
References: <48C9D040.8010107@lwfinger.net>	<f488382f0809111932v1cc1eb44kbe0bc0e97347c834@mail.gmail.com>	<48C9DACE.5040308@lwfinger.net> <adavdx2kqt5.fsf@cisco.com>
In-Reply-To: <adavdx2kqt5.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roland Dreier wrote:
>  > This one gets rid of the sparse warning.
>  > 
>  >        priv->rx_mtu = le16_to_cpu((__le16 __force)
>  >                                   bootrec->data[10]);
> 
> Yes but does it actually work on both big and little endian systems?
> (See my previous email)

I don't know, but as my previous email stated, the code could not 
possibly have worked on a big-endian system before I started the 
sparse cleanup. I don't have access to anything but little-endian 
hardware.

Larry
