Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2883 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab1GETrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 15:47:06 -0400
Message-ID: <4E136A27.6060207@broadcom.com> (sfid-20110705_214712_621161_1E2ABDEF)
Date: Tue, 5 Jul 2011 21:46:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and
 bug fixed
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <20110705165949.GA18531@kroah.com> <4E1362D5.2040806@broadcom.com>
In-Reply-To: <4E1362D5.2040806@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2011 09:15 PM, Arend van Spriel wrote:
> On 07/05/2011 06:59 PM, Greg KH wrote:
>> On Wed, Jun 29, 2011 at 04:46:24PM -0700, Franky Lin wrote:
>>> Most of these patches are brcmfmac cleanup.
>> Not all of them applied, care to redo the ones that didn't and resend
>> them?
>>
>> thanks,
>>
>> greg k-h
> Will do when I figured out which ones are not applying. Franky, as are
> all valley broadcom folks, is not in today (fourth of july aftermath).
> Here in Holland we have other days to celebrate so taking over from him.
> Can you provide me the info about the not applying patches. I applied
> them all on top of staging-next as it was this morning and that went
> fine. Did we miss some brcm80211 patches not coming from us? I will
> start digging here to find out, but you are more than welcome to provide
> any info.
>
> Gr. AvS

Hi Greg,

This is what I excavated so far. Looking at git.kernel.org it seems like 
patch 92 in the series got applied at the end of the series. Up to patch 
92 it went fine, but it started to derail from there. I have clear 
picture which patches are missing and will resend them.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


