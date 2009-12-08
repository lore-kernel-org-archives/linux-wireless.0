Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:40963 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZLHKzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 05:55:18 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1078740qwe.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 02:55:24 -0800 (PST)
References: <1260237325-8654-1-git-send-email-lrodriguez@atheros.com> <4B1DDB77.6070909@myrealbox.com> <43e72e890912072221j660f9a6dpa8cf9257db14da41@mail.gmail.com>
Message-Id: <EB65E7CB-4E8C-4587-A563-A4F5185C5D80@gmail.com>
From: Andy Lutomirski <amluto@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <43e72e890912072221j660f9a6dpa8cf9257db14da41@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH] iw: add HT capability parsing for scanning
Date: Tue, 8 Dec 2009 05:54:57 -0500
Cc: Andy Lutomirski <luto@myrealbox.com>,
	"johannes@sipsolutions.ney" <johannes@sipsolutions.ney>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Dec 8, 2009, at 1:21 AM, "Luis R. Rodriguez"  
<lrodriguez@atheros.com> wrote:

> On Mon, Dec 7, 2009 at 8:52 PM, Andy Lutomirski <luto@myrealbox.com>  
> wrote:
>> Luis R. Rodriguez wrote:
>>>
>>> This adds HT capability IE parsing for scanning. You will now
>>> be able to easily review what HT capabilities your AP supports
>>> with a simple iw scan.
>>>
>>
>>> +       default:
>>> +               return "Uknown";
>>> +       }
>>> +}
>>> +
>>
>> Unknown?
>
> Could've called it "caca", but this seemed more appropriate.

Sure, but a second "n" might be more respectful to the AP. :)

--Andy

>
>  Luis
> ---- Content & Policy Scan by M+ Guardian ----
> Millions of safe & clean messages delivered daily
>
>
