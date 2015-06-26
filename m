Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37818 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbbFZBcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 21:32:19 -0400
Received: by wicgi11 with SMTP id gi11so4707331wic.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 18:32:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com>
References: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com>
Date: Fri, 26 Jun 2015 09:32:18 +0800
Message-ID: <CAEFj984fG7oidP_u2vnH6p+VigjX_NF29JOfFWeAara8GCaiCg@mail.gmail.com> (sfid-20150626_033224_402012_F7E8D1D4)
Subject: Re: [PATCH] mac80211: mesh - don't special case routing to transmitter
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 25, 2015 at 9:55 AM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> Updating the path to the transmitter of a path message is optional
>> according to section 13.10.8.4 of the standard. Doing so can lead to
>> better performance since we can adjust the route to the transmitter based
>> on the freshest possible information. However it can also cause routing
>> loops with more than four or five nodes.
>
> Do you have the test scenario on how routing loops happen in this case?
>

Sorry, I don't see the "optional" work in section 13.10.8.4. Please
note that this maybe useful for most of the cases.

I would recommend to add nl80211 command for doing so. So, others
still can enjoy freshest possible information. What do you think?

----
Chun-Yeow
