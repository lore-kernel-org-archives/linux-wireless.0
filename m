Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1799 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab1EZRxo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 13:53:44 -0400
Message-ID: <4DDE9391.6020302@broadcom.com> (sfid-20110526_195348_614183_AD2B4A79)
Date: Thu, 26 May 2011 19:53:21 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Daniel Halperin" <dhalperi@cs.washington.edu>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Subject: Re: %d in wlan log messages
References: <4DDE63B4.4030309@broadcom.com>
 <BANLkTina0R-SJamJ_GFbxJsYcvvdyxzZNg@mail.gmail.com>
In-Reply-To: <BANLkTina0R-SJamJ_GFbxJsYcvvdyxzZNg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2011 05:09 PM, Daniel Halperin wrote:
> On Thu, May 26, 2011 at 7:29 AM, Arend van Spriel<arend@broadcom.com>  wrote:
>> [  563.120590] wlan%d: authenticate with c0:c1:c0:04:b8:2c (try 1)
>> [  563.128143] wlan%d: authenticated
>> [  563.131517] wlan%d: associate with c0:c1:c0:04:b8:2c (try 1)
>> [  563.140933] wlan%d: RX AssocResp from c0:c1:c0:04:b8:2c (capab=0x411
>> status=0 aid=4)
>> [  563.148714] wlan%d: associated
>> [  563.177019] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>>
>> On latest staging-next I noticed above mentioned log messages. I assume
>> these message are from cfg80211 or mac80211. Has this been reported?
>>
> Interface names [including any numbers] are set by userspace, right?
> On my Ubuntu 10.04.2 LTS system, it's
> /etc/udev/rules.d/70-persistent.net.rules (or so, this is from
> memory). Not a kernel bug.
>
> Dan

Weird. I did not change anything in udev rules (using Ubuntu 10.10 over 
here). So the only variant in my setup is move to 2.6.39. Can you 
explain that netdev apparently has the proper interface id (see 
timestamp [563.177019] above?

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


