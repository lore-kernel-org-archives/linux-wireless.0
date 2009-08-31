Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:52977 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZHaSlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 14:41:22 -0400
Received: by iwn42 with SMTP id 42so1921796iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 11:41:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890908311132g16783b68y2d1771ce1d2780d@mail.gmail.com>
References: <h7eo7q$7ks$1@ger.gmane.org> <3ace41890908311055s5c49a25fjf69ca48024579d44@mail.gmail.com>
	<43e72e890908311102q2ed9e8b3q8f1f15d45a29b2f1@mail.gmail.com>
	<3ace41890908311132g16783b68y2d1771ce1d2780d@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Aug 2009 11:41:03 -0700
Message-ID: <43e72e890908311141k6bcf5edbl6bce2b88670fb5f8@mail.gmail.com>
Subject: Re: rtl8187b Problem with tx level
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Tobias Schlemmer <keinstein_junior@gmx.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2009 at 11:32 AM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> On Mon, Aug 31, 2009 at 7:02 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> On Mon, Aug 31, 2009 at 10:55 AM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>>> On Sun, Aug 30, 2009 at 9:44 PM, Tobias
>>> Schlemmer<keinstein_junior@gmx.net> wrote:
>>>> Hi,
>>>>
>>>> I have some problem with my rtl8187b device. It is included in my laptop
>>>> running Ubuntu linux 2.6.28. I've tested several compat-wireless releases
>>>> including 2.6.30 and 2.6.31-rc7.
>>>
>>> Hmm, are compat-wireless versioned against kernels?
>>
>> The stable ones are:
>>
>> http://wireless.kernel.org/en/users/Download/stable/
>>
>>  Luis
>>
>
> Thanks - it is new addition to the web-site :-), I see.

Yup, and when 2.6.32-rc1 is released we'll have another
compat-wireless tarball made from that as well.

> Anyway, Larry
> and Herton have made more changes/improvements in rtl8187 in
> latest-and-greatest than 2.6.31-rc7...

Thanks for the heads up, what I recommend is you edit the
wireless.kernel.org wiki page for rtl8187 and put there a section of
'recommended version' and explain what kernel release you expect to
work the best, and if you do recommend latest and greatest put that on
the wiki. This is what we did for ath9k as ath9k changes kept coming
in for ath9k through kernel releases and distributions were still on
old versions of it. What I hope is eventually users will just know to
check wireless.kernel.org driver page for details for their own
drivers.

  Luis
