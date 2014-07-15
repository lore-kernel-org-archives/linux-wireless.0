Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39120 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbaGOTrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 15:47:39 -0400
Received: by mail-ob0-f182.google.com with SMTP id wm4so6265310obc.13
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 12:47:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140715193011.GE26012@tuxdriver.com>
References: <1404846019-11079-1-git-send-email-zajec5@gmail.com>
	<20140715193011.GE26012@tuxdriver.com>
Date: Tue, 15 Jul 2014 21:47:38 +0200
Message-ID: <CACna6ryHYG-TNRBfHvsCQoN3FvGjWrVyqPpmaRZB1MLq4PyUKg@mail.gmail.com> (sfid-20140715_214745_347367_4D42931C)
Subject: Re: [PATCH][3.16 MAYBE?] b43: don't warn about no 5 GHz support on
 2.4 GHz devices
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 July 2014 21:30, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Jul 08, 2014 at 09:00:19PM +0200, Rafał Miłecki wrote:
>> This could be a bit confusing to see warning about lacking support for
>> 5 GHz band if your device supports 2.4 GHz only.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> John: even I was quite confused to see this warning on my BCM5357. I
>> suspected b43 incorrectly detected my WiFi as 5 GHz capable. I think
>> that proposed behavior makes more sense.
>> Do you think it's OK/worth to take it for 3.16?
>
> I don't really think it merits prommotion to 3.16.  I am happy to
> merge it for -next.

OK, no problem, thanks :)

-- 
Rafał
