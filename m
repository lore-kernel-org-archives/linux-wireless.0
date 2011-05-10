Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2929 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1EJTHq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:07:46 -0400
Message-ID: <4DC98CF2.9050804@broadcom.com> (sfid-20110510_210749_143225_E088F76C)
Date: Tue, 10 May 2011 21:07:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/10] staging: brcm80211: cleanup unnecessary
 functions from wlc_ampdu.c
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
 <20110510181208.GA3396@kroah.com>
In-Reply-To: <20110510181208.GA3396@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 08:12 PM, Greg KH wrote:
> On Mon, May 09, 2011 at 04:33:20PM +0200, Arend van Spriel wrote:
>> Couple of functions are not used or empty and have been removed.
> This patch doesn't apply on top of all of the other brcm80211 patches
> sent me.  Care to redo this series and resend after syncing up with the
> next linux-next tree?
According to the email messages 'patch "staging: brcm80211: ..." added 
to staging tree' you dropped four patches in this series. Do you want me 
to resend those or the entire series. I prefer only resending the 
dropped ones, but it is your call.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


