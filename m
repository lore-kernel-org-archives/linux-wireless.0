Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:15866 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYILDEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 23:04:40 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Steven Noonan <steven@uplinklabs.net>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: I need help with a sparse warning
References: <48C9D040.8010107@lwfinger.net>
	<f488382f0809111932v1cc1eb44kbe0bc0e97347c834@mail.gmail.com>
	<48C9DACE.5040308@lwfinger.net>
Date: Thu, 11 Sep 2008 20:04:38 -0700
In-Reply-To: <48C9DACE.5040308@lwfinger.net> (Larry Finger's message of "Thu,
	11 Sep 2008 21:58:22 -0500")
Message-ID: <adavdx2kqt5.fsf@cisco.com> (sfid-20080912_050444_248248_2B67049D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > This one gets rid of the sparse warning.
 > 
 >        priv->rx_mtu = le16_to_cpu((__le16 __force)
 >                                   bootrec->data[10]);

Yes but does it actually work on both big and little endian systems?
(See my previous email)

 - R.
