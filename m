Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35435 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbbFNXOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 19:14:00 -0400
Received: by oihd6 with SMTP id d6so48701686oih.2
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jun 2015 16:14:00 -0700 (PDT)
Message-ID: <557E0AB4.2030001@lwfinger.net> (sfid-20150615_011413_230574_5A1EF7BE)
Date: Sun, 14 Jun 2015 18:13:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James Cameron <quozl@laptop.org>
CC: Arnaud LE CAM <arnaud.lecam@yahoo.fr>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Bug ?] 10ec:b723 Realtek RTL8723BE wireless card drops connection
References: <1434268591.3014.YahooMailBasic@web172003.mail.ir2.yahoo.com> <557D9966.5050209@lwfinger.net> <20150614230456.GE12739@us.netrek.org>
In-Reply-To: <20150614230456.GE12739@us.netrek.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2015 06:04 PM, James Cameron wrote:
> On Sun, Jun 14, 2015 at 10:10:30AM -0500, Larry Finger wrote:
>> To address your problem, power saving does not work correctly on
>> this device. That is why there are numerous posts on the web telling
>> people to use ips=0. It seems that Ubuntu people never look at
>> anything but the Ubuntu literature; however, I'm sure that I posted
>> this "suggestion" there as well. The Realtek group is currently
>> rewriting the entire dynamic management code for all their drivers.
>> When complete, this should improve performance and should help the
>> power-save condition. No, I do not know when the new code will be
>> ready, or how much improvement it will make.
>
> Thanks for summary.
>
> OLPC is also seeing the issue.  Power saving mode impacts battery run
> time; one of our design goals.  ips=0 seems to solve with 3.19, but
> not fully with 4.1-rc7; still some periods of packet loss.
>
> I offer to test any rtl8723be changes.

Please do a bisection between 4.1-rc7 and 3.19.

Larry
