Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45154 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab1EOBXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 21:23:06 -0400
Received: by bwz15 with SMTP id 15so2947641bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 18:23:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DCE9DB8.7080404@lwfinger.net>
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>
	<4DCB3DFF.1030809@lockie.ca>
	<BANLkTimEWJbgJJOmCjBoNGtFrSFcoE8aWQ@mail.gmail.com>
	<4DCE9DB8.7080404@lwfinger.net>
Date: Sat, 14 May 2011 20:23:04 -0500
Message-ID: <BANLkTikHk=yVQ64OJKBcC9QtYP6OOGrmPw@mail.gmail.com> (sfid-20110515_032330_702710_1ED592B4)
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
From: Flaminigo <sunnyiez@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: James <bjlockie@lockie.ca>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much. I've forwarded your mail to administrator. But he
didn't reply me. I am still waiting. I will let you know asap when he
replies me.
Regards
Sunny

On Sat, May 14, 2011 at 10:20 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 05/12/2011 08:59 AM, Flaminigo wrote:
>>
>> Thank you for the reply. I think N network in the university is OK.
>> Because,  old computer connected it without any problem. The windows
>> system can also connect it. From the output of wpa_supplicant, the
>> authentication part works well. I've tried to use the latest drive
>> from realtek. The firmware distribute is exactly the same as that in
>> Ubuntu 11.04. But this will make core dump.
>
> There is a problem with driver rtl8192ce with 802.11n networks that use a 40
> MHz bandwidth. As you never answered my questions, I don't know if that is
> the problem that you are seeing. If you go to
> http://bugzilla.kernel.org/show_bug.cgi?id=35082, there is a patch that may
> fix your problem. At least it worked here.
>
> Larry
>
>
