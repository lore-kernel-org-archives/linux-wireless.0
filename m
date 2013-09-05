Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59469 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3IEFDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 01:03:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] qca-swiss-army-knife: add ath10k trace-cmd plugin
References: <1376939466-8282-1-git-send-email-kvalo@qca.qualcomm.com>
	<1376939466-8282-2-git-send-email-kvalo@qca.qualcomm.com>
	<CAB=NE6UCmO4QbFjtav8xPDAoebpTqDNwz_qQxg1TQ8cKGcbFGg@mail.gmail.com>
	<871u53swie.fsf@kamboji.qca.qualcomm.com>
	<1378357025.1787.79.camel@joe-AO722>
Date: Thu, 5 Sep 2013 08:03:44 +0300
In-Reply-To: <1378357025.1787.79.camel@joe-AO722> (Joe Perches's message of
	"Wed, 4 Sep 2013 21:57:05 -0700")
Message-ID: <87sixjrhan.fsf@kamboji.qca.qualcomm.com> (sfid-20130905_070353_160400_76637B24)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Thu, 2013-09-05 at 07:49 +0300, Kalle Valo wrote:
>> "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> writes:
>> > I just removed 3 trailing spaces on the 2 patches. One had two
>> > trailing spaces, the last patch had one.
>> 
>> Oh, sorry about that. Any ideas how I could check for those myself?
>
> scripts/checkpatch.pl <patch>

Checkpatch works also with trace-cmd plugins written in python?

> git am <patch>

Yeah, I guess I could do that, it's just a bit inconvienient.

-- 
Kalle Valo
