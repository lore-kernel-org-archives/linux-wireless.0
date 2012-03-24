Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2237 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab2CXJ2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Mar 2012 05:28:12 -0400
Message-ID: <4F6D939F.3030206@broadcom.com> (sfid-20120324_102815_365935_20B03881)
Date: Sat, 24 Mar 2012 10:27:59 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
References: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com>
In-Reply-To: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2012 09:55 AM, Camaleón wrote:
> How to reproduce the problem:
> After booting the system, I get a trace (see attached file "messages.txt")
>

Hi Camaleón,

 From the trace I see that your system apparently is setup for 
regulatory domain EU. Could you configure it US instead. I think 
brcmsmac is not handling the channel 12 and 13 properly. Is you AP on 
either of these channels? Regardless, mac80211 will probably switch to 
those channels for (passive) scanning.

Gr. AvS

