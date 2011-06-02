Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2339 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759381Ab1FBIc4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 04:32:56 -0400
Message-ID: <4DE74AAF.2060800@broadcom.com> (sfid-20110602_103301_634958_5E7E36E4)
Date: Thu, 2 Jun 2011 10:32:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "Roland Vossen" <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 35/83] staging: brcm80211: moved header files to
 more specific directory
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-35-git-send-email-rvossen@broadcom.com>
 <BANLkTimGZiOaSmAJ7xeH+=0LK2+Rqit3zw@mail.gmail.com>
In-Reply-To: <BANLkTimGZiOaSmAJ7xeH+=0LK2+Rqit3zw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/2011 02:08 AM, Julian Calaby wrote:
> On Wed, Jun 1, 2011 at 21:45, Roland Vossen<rvossen@broadcom.com>  wrote:
>> Code cleanup. Header files only used by the softmac were moved to the
>> brcmsmac dir, same approach for fullmac header files.
>>
>> Signed-off-by: Roland Vossen<rvossen@broadcom.com>
>> Reviewed-by: Arend van Spriel<arend@broadcom.com>
> Again, should there be some code changes associated with the header
> file move or am I missing something?

Hi Julian,

This change (and 38/83) move the include file from brcm80211/include to 
brcmfmac or brcmsmac depending which driver is actually using it. So 
these include files can still be found by the preprocessor and no other 
changes are needed to make it compile. The remaining issue would be a 
style issue replacing brackets by quotes. Roland is currently going over 
all c sources to cleanup file inclusion and the style issue is part of 
that cleanup. Not sure if this is kind of code change you were 
expecting. If not please give some more hints ;-)

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


