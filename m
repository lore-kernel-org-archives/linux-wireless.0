Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4710 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab1LPOBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 09:01:00 -0500
Message-ID: <4EEB4F09.6080806@broadcom.com> (sfid-20111216_150124_001945_0A4416BA)
Date: Fri, 16 Dec 2011 15:00:41 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unexpected taint message
References: <4EEB0EFC.5000302@broadcom.com> (
 sfid-20111216_102800_182196_AFD2D6CF)
 <1324038636.3429.1.camel@jlt3.sipsolutions.net>
 <4EEB4D61.80602@lwfinger.net>
In-Reply-To: <4EEB4D61.80602@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2011 02:53 PM, Larry Finger wrote:
> 
> I also found that loading brcmsmac did not trigger the license taint. I think 
> you are OK with the dual license.

Ok. I get it upon loading the brcmutil module. Actually, my usage
scenario is:

1) build the driver modules in kernel tree on my development machine.
2) rsync the brcm80211 folder to my test machine.
3) insert the driver modules on my test machine.

> Larry
> 

Gr. AvS

