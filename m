Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:65354 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3KZUqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 15:46:30 -0500
Received: by mail-la0-f44.google.com with SMTP id ep20so4763493lab.31
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 12:46:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385490243.7838.16.camel@dcbw.foobar.com>
References: <CAKnB8xgAVp+Ti597RN4_kgPLgXpW1JCr4SQaqfqCzy5A4=o3Ow@mail.gmail.com>
	<CAKnB8xh6tWFdiL4kBQ5r3J_YgiiwhHhvQEqC+9F7c=3eAsrYbg@mail.gmail.com>
	<5294E46C.40102@erley.org>
	<1385490243.7838.16.camel@dcbw.foobar.com>
Date: Tue, 26 Nov 2013 21:46:29 +0100
Message-ID: <CAEk6gTAXXNFbRTqVNGZWnVBpNSW=HKz3qztdZ1t1vMZLe530Hg@mail.gmail.com> (sfid-20131126_214633_559933_85FA4900)
Subject: Re: Fwd: Intel 7260
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Pat Erley <pat-lkml@erley.org>, matt emery <matt@x204.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 26, 2013 at 7:24 PM, Dan Williams <dcbw@redhat.com> wrote:
>> While I'm not certain about your AP or the 7260 driver, I believe
>> 802.11n technically requires WPA2 encryption.  Try turning that on and
>> testing again.
>
> This is true, but...

802.11n HT prevents WPA:
http://www.slideshare.net/HPenterprise/demystifying-80211n-and-wpawpa2,slide
4

I do not see however that using no encryption is prevented by the standard...

BR,
Drasko
