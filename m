Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:36101 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcEVCZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2016 22:25:07 -0400
Received: by mail-qg0-f45.google.com with SMTP id w36so76565648qge.3
        for <linux-wireless@vger.kernel.org>; Sat, 21 May 2016 19:25:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160520.194148.1467687685270353684.davem@davemloft.net>
References: <87eg8yfc8b.fsf@kamboji.qca.qualcomm.com>
	<20160520.194148.1467687685270353684.davem@davemloft.net>
Date: Sat, 21 May 2016 20:25:05 -0600
Message-ID: <CAAA5faFVE+wd5hLFRjeDZNTM1Lg1rCdMRUbYAZiVEH_yJNqa6A@mail.gmail.com> (sfid-20160522_042518_496519_900DC08F)
Subject: Re: pull-request: wireless-drivers-next 2016-05-13 (take two)
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 20, 2016 at 5:41 PM, David Miller <davem@davemloft.net> wrote:
> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Thu, 19 May 2016 15:45:08 +0300
>
>> this the second version of the last pull request to net-next for 4.7,
>> which got postponed due to the recent iwlwifi merge conflict. Now that
>> Linus fixed the merge problem in his tree I actually didn't have to fix
>> anything in my tree anymore. So that's why I still use the same tag as
>> in my previous pull request.
>>
>> The only dependency is that you need Linus' iwlwifi fix in your tree
>> before you pull this:
>>
>> 0e034f5c4bc4 iwlwifi: fix mis-merge that breaks the driver
>>
>> So if you could pull latest Linus' tree to net-next that would solve
>> that. I just did a test merge of that on your net-next tree and didn't
>> see any conflicts, so this pull should go smoothly. Also these patches
>> have been in linux-next at least a week now. But please let me know if
>> you see any issues.
>
> Done, pulled, thanks a lot!
>

Forgive my ignorance here, but I cannot find it in 4.6+
Is this merged in another branch or do I have an issue with my copy of 4.6+?
I am anxious to try it out.

>> And I think a lesson learned from this is that I need to immediately
>> merge wireless-drivers to wireless-drivers-next if there are any
>> conflicts between the trees. Or how do you suggest to handle cases like
>> that?
>
> You shouldn't have to worry about this kind of stuff at all, and let's
> just hope I handle the conflict better next time. :-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
