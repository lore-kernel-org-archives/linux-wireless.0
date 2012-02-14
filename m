Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3315 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592Ab2BNKHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 05:07:30 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Saul St. John" <saul.stjohn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: =?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Date: Tue, 14 Feb 2012 02:07:13 -0800
Subject: RE: [RFC] use alternate SPROM offset for 43224
Message-ID: <400C43189542CE41BC0A5B252FC90136BC8414CAF4@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20120214_110737_267868_792DF8CE)
References: <20120214040120.GA2077@eris.garyseven.net>
In-Reply-To: <20120214040120.GA2077@eris.garyseven.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> owner@vger.kernel.org] On Behalf Of Saul St. John
> Sent: dinsdag 14 februari 2012 5:01
> 
> I don't know if this is correct in the general sense, but the wireless
> on my
> mid-2010 MacBook Pro doesn't work without it.
> 
> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>

Does this patch solve the same issue as [1] with title:

[PATCH] bcma: don't fail for bad SPROM CRC

Gr. AvS

[1] http://www.spinics.net/lists/netdev/msg187943.html

