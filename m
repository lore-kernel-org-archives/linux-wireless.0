Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:37612 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3COCHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 22:07:36 -0400
Received: by mail-qe0-f43.google.com with SMTP id 1so1661513qee.30
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2013 19:07:36 -0700 (PDT)
Message-ID: <51428265.1090202@lwfinger.net> (sfid-20130315_030740_647210_93FEDF43)
Date: Thu, 14 Mar 2013 21:07:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: isedev@gmail.com
CC: Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net> <2065763.l9B10YbWFg@wks001.ise.net>
In-Reply-To: <2065763.l9B10YbWFg@wks001.ise.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/14/2013 07:09 PM, ISE Development wrote:
> On Thursday 14 Mar 2013 13:46:19 Larry Finger wrote:
>> +                       if (unlikely(!skip))
>> +                               txstat = status;
>> +                       else
>> +                               txstat = &fake;
>
> The logic should probably be reversed. It's more unlikely to skip than not to
> do so (hopefully!)...

Yes, you are correct.

Larry


