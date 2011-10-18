Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3354 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab1JRNPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 09:15:06 -0400
Message-ID: <4E9D7BCD.1050104@broadcom.com> (sfid-20111018_151531_896348_F432E0DE)
Date: Tue, 18 Oct 2011 15:14:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Nico Schottelius" <nico-linux-20111017@schottelius.org>
cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
References: <20111018111422.GA1979@schottelius.org>
In-Reply-To: <20111018111422.GA1979@schottelius.org>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2011 01:14 PM, Nico Schottelius wrote:
> Dear LKML,

In this case linux-wireless list may be more appropriate, adding it.

> The hardware is again the (in)famous MacBook Air 4,2, so I imagine this may be
> related to brcmsmac.
> 
> Attached are config, dmesg, lsmod.

In the dmesg I see a lot of PM messages. Did you do a suspend/resume or
hibernate? Trying to determine the scenario so any more info is appreciated.

> 
> Cheers,
> 
> Nico
> 

Gr. AvS

