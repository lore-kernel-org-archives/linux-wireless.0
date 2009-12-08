Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50686 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZLHPtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 10:49:08 -0500
Received: by iwn1 with SMTP id 1so3826302iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 07:49:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <EB65E7CB-4E8C-4587-A563-A4F5185C5D80@gmail.com>
References: <1260237325-8654-1-git-send-email-lrodriguez@atheros.com>
	<4B1DDB77.6070909@myrealbox.com> <43e72e890912072221j660f9a6dpa8cf9257db14da41@mail.gmail.com>
	<EB65E7CB-4E8C-4587-A563-A4F5185C5D80@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 8 Dec 2009 07:48:55 -0800
Message-ID: <43e72e890912080748k14a4d579kc055b340278a3a3f@mail.gmail.com>
Subject: Re: [PATCH] iw: add HT capability parsing for scanning
To: Andy Lutomirski <amluto@gmail.com>
Cc: Andy Lutomirski <luto@myrealbox.com>,
	"johannes@sipsolutions.ney" <johannes@sipsolutions.ney>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2009 at 2:54 AM, Andy Lutomirski <amluto@gmail.com> wrote:
>
>
> On Dec 8, 2009, at 1:21 AM, "Luis R. Rodriguez" <lrodriguez@atheros.com>
> wrote:
>
>> On Mon, Dec 7, 2009 at 8:52 PM, Andy Lutomirski <luto@myrealbox.com>
>> wrote:
>>>
>>> Luis R. Rodriguez wrote:
>>>>
>>>> This adds HT capability IE parsing for scanning. You will now
>>>> be able to easily review what HT capabilities your AP supports
>>>> with a simple iw scan.
>>>>
>>>
>>>> +       default:
>>>> +               return "Uknown";
>>>> +       }
>>>> +}
>>>> +
>>>
>>> Unknown?
>>
>> Could've called it "caca", but this seemed more appropriate.
>
> Sure, but a second "n" might be more respectful to the AP. :)

That is true :), thanks for the pointer, will leave it like that for
now unless Johannes really wants a resend.

  Luis
