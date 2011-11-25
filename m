Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3877 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab1KYIrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 03:47:08 -0500
Message-ID: <4ECF55FE.8080905@broadcom.com> (sfid-20111125_094729_221224_BAC7AA34)
Date: Fri, 25 Nov 2011 09:46:54 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ben Greear" <greearb@candelatech.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v10 2/2] mac80211:  Support ht-cap over-rides.
References: <1321644720-8245-1-git-send-email-greearb@candelatech.com>
 <1321644720-8245-2-git-send-email-greearb@candelatech.com> (
 sfid-20111118_203218_329178_9FB3658A)
 <1321648257.10266.77.camel@jlt3.sipsolutions.net>
 <4EC6C36D.4070900@candelatech.com>
 <1322142597.5366.19.camel@jlt3.sipsolutions.net>
 <4ECE9825.8070208@candelatech.com>
In-Reply-To: <4ECE9825.8070208@candelatech.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2011 08:16 PM, Ben Greear wrote:
> On 11/24/2011 05:49 AM, Johannes Berg wrote:
>> Please fix:
>>
>> net/mac80211/ht.c:31:6: warning: symbol '__check_htcap_disable' was not
>> declared. Should it be static?
> 
> I sent a patch to make this static, but I do not see the warning.  Are you
> running something other than a standard 'make bzImage modules' to
> see this warning?
> 
> Thanks,
> Ben
> 

This is probably a sparse warning so you need to add C=2 on the command
line.

Gr. AvS

