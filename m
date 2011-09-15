Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2269 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933377Ab1IOLxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 07:53:55 -0400
Message-ID: <4E71E749.5020402@broadcom.com> (sfid-20110915_135418_203702_13934C1A)
Date: Thu, 15 Sep 2011 13:53:45 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Greg KH" <greg@kroah.com>, "Greg KH" <gregkh@suse.de>,
	"Francis Moreau" <francis.moro@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Michael Buesch" <mb@bu3sch.de>
Subject: Re: About the patch:
 "staging: brcm80211: only enable brcmsmac if bcma is not set"
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
 <CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
 <20110913174444.GG11772@tuxdriver.com>
 <CACna6rwS0dGwSFOiqgAYqHNV=AatnHvHes=YdbwSWdKZu8OYiQ@mail.gmail.com>
 <400C43189542CE41BC0A5B252FC90136BC0C9DEF38@SJEXCHCCR02.corp.ad.broadcom.com>
 <CACna6rzK86LQ4bULMvcfTTwtDxAGtDzc8K+uGobarnkOpax17w@mail.gmail.com>
In-Reply-To: <CACna6rzK86LQ4bULMvcfTTwtDxAGtDzc8K+uGobarnkOpax17w@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2011 10:18 PM, Rafał Miłecki wrote:
> W dniu 14 września 2011 11:23 użytkownik Arend Van Spriel
> <arend@broadcom.com>  napisał:
>> For my bcma integration effort (which is already stale due to our brcmsmac cleanup) I simply took "wireless-next" bcma using meld. Was surprised that I also needed to do this for ssb as there are some include dependencies. In early bcma discussions a strong preference was given (by Michael if I am correct) to keep bcma independent from ssb at the cost of some duplication. For include files this preference might be less strong, but I still think it is a good idea to have these chip interconnect bus drivers independent from each other.
> The code is independent, if some includes are not, that should be
> reported&  fixed.

No problem. Will look into it.

Gr. AvS

