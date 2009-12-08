Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:62964 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbZLHGVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 01:21:32 -0500
Received: by iwn35 with SMTP id 35so3663188iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 22:21:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B1DDB77.6070909@myrealbox.com>
References: <1260237325-8654-1-git-send-email-lrodriguez@atheros.com>
	<4B1DDB77.6070909@myrealbox.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 7 Dec 2009 22:21:19 -0800
Message-ID: <43e72e890912072221j660f9a6dpa8cf9257db14da41@mail.gmail.com>
Subject: Re: [PATCH] iw: add HT capability parsing for scanning
To: Andy Lutomirski <luto@myrealbox.com>
Cc: johannes@sipsolutions.ney, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 7, 2009 at 8:52 PM, Andy Lutomirski <luto@myrealbox.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> This adds HT capability IE parsing for scanning. You will now
>> be able to easily review what HT capabilities your AP supports
>> with a simple iw scan.
>>
>
>> +       default:
>> +               return "Uknown";
>> +       }
>> +}
>> +
>
> Unknown?

Could've called it "caca", but this seemed more appropriate.

  Luis
