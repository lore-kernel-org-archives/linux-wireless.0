Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2612 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab1KJSuv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 13:50:51 -0500
Message-ID: <4EBC1CF8.8080704@broadcom.com> (sfid-20111110_195108_551536_14F976E4)
Date: Thu, 10 Nov 2011 19:50:32 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <gregkh@suse.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3.1-stable] staging: brcm80211: fix for rate index
 in receive status
References: <1320918514-5916-1-git-send-email-arend@broadcom.com>
 <20111110151746.GB29104@suse.de> <4EBC19D6.2070806@broadcom.com>
 <20111110184457.GA8010@suse.de>
In-Reply-To: <20111110184457.GA8010@suse.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2011 07:44 PM, Greg KH wrote:
> On Thu, Nov 10, 2011 at 07:37:10PM +0100, Arend van Spriel wrote:
>> On 11/10/2011 04:17 PM, Greg KH wrote:
>>
>> Here it is:
>>
>> commit 5a84d6ad4c9306afb467a600a4c6d7b50da49440
>> Author: Arend van Spriel <arend@broadcom.com>
>> Date:   Tue Aug 23 14:14:00 2011 +0200
>>
>>     staging: brcm80211: fill in proper rx rate in mac80211 rx status
>>
>>     The brcmsmac driver supports different rates on 5GHz but this is not
>>     taken into account when providing the rate index in the receive
>>     status information passed to mac80211.
>>
>>     Reviewed-by: Roland Vossen <rvossen@broadcom.com>
>>     Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>     Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
>>     Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Thanks, that's what I need.  I'll queue this up for the next 3.1 kernel
> after this one gets out later this week.
> 
> greg k-h
> 

Fine by me.

Gr. AvS

