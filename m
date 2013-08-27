Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:19499 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab3H0I2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:28:22 -0400
Message-ID: <521C61AC.9020508@allnet.de> (sfid-20130827_102843_657450_018A31EA)
Date: Tue, 27 Aug 2013 10:22:04 +0200
From: Daniel Golle <dgolle@allnet.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Paul Menzel <paulepanter@users.sourceforge.net>,
	Fabien ADAM <id2ndr@crocobox.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [PATCH 3.11] rt2800: fix wrong TX power compensation
References: <20130826131851.GB10525@redhat.com> <1377548398.4408.4.camel@mattotaupa> <20130827080001.GA2609@redhat.com>
In-Reply-To: <20130827080001.GA2609@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2013 10:00 AM, Stanislaw Gruszka wrote:
> On Mon, Aug 26, 2013 at 10:19:58PM +0200, Paul Menzel wrote:
>> Could you please add which ones you have tested?
> 
> I checked 2 devices (3071 & 3070) but they have EXTERNAL_TX_ALC bit set.
> I assume the fix is correct based on vendor driver and it fixes devices
> which have no EXTERNAL_TX_ACL, but I can not tell what chipset that are.
> Is possible that the same chipset can be configured with and without
> EXTERNAL_TX_ALC.

At least for SoC (3352 and 5350) I know that there are devices with (e.g.
DIR-615 rev.H1) and without EXTERNAL_TX_ALC (e.g. ALL5002). I guess the same
applies for PCI modules.

