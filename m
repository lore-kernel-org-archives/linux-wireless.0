Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:43077 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaEZJqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:46:50 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so7812274wes.34
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 02:46:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401097086.29704.0.camel@jlt4.sipsolutions.net>
References: <1401089962-10720-1-git-send-email-chaitanya.mgit@gmail.com> <1401097086.29704.0.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 26 May 2014 15:16:28 +0530
Message-ID: <CABPxzYKe5Cy36uc=C5wVEVZV0qiR=55yBw0LtzuRv412p58c9g@mail.gmail.com> (sfid-20140526_114653_228504_5B9059AD)
Subject: Re: [regdb] Add support to parse 2000mW tx power
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <mcgrof@gmail.com>,
	wireless-regdb@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 3:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-05-26 at 13:09 +0530, chaitanya.mgit@gmail.com wrote:
>
>> @@ -74,7 +74,7 @@ function parse_reg_rule()
>>                       power = 23
>>               } else if (power == 500) {
>>                       power = 27
>> -             } else if (power == 1000) {
>> +             } else if ((power == 1000) || (power == 2000)) {
>>                       power = 30
>
> This seems like a pretty sick thing to do to start with, and certainly

Agree.

> power=30 isn't right for 2000mW...

Sorry, typo. Its supposed to be 33.

> Can't awk calculate the logarithm?
Does kernel support log arithmetic/Float operations.?
