Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42107 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760008Ab3BHPCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 10:02:53 -0500
Message-ID: <5115138C.5070106@candelatech.com> (sfid-20130208_163816_078476_FFC1AD73)
Date: Fri, 08 Feb 2013 07:02:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Amit SHAKYA <amit.shakya@stericsson.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Fix PN corruption in case of multiple virtual
 interface
References: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com>  <1359991708.10311.15.camel@jlt4.sipsolutions.net>  <ECD438FDEF6BD742895E554C24725A40236E82519C@EXDCVYMBSTM005.EQ1STM.local>  <201302061433.19375.chunkeey@googlemail.com>  <ECD438FDEF6BD742895E554C24725A40236E825AFA@EXDCVYMBSTM005.EQ1STM.local> <1360313413.8166.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360313413.8166.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2013 12:50 AM, Johannes Berg wrote:
> Hi Amit,
>
>
>> Actually I debugged this issue quite some time back for a customer project. Now I don’t have the setup also as I have moved out of the project.
>>
>> So I am afraid I will not be able to test it.
>
> Ah, too bad.
>
> Christian, I think regardless of that your version is much better, can
> you send it?
>
> Ben, maybe you've seen this as well, with your many interfaces
> testing? :-)

Well, I know (total) throughput goes to shit when I add 100+ interfaces, but I'm
not sure why..I assumed it was mainly because the MPDU logic didn't work
well when there are lots of slow traffic flows and haven't made any real
attempt to figure out if that is true or not.

I'm feverishly trying to get a stable 3.7 out the door, but as soon
as that goes, I'll start some testing on whatever is the latest upstream
code again, and run some more detailed tests on throughput with lots of
interfaces...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

