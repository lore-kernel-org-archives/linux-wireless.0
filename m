Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40378 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2AZPfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 10:35:53 -0500
Received: by ghrr11 with SMTP id r11so277045ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 07:35:52 -0800 (PST)
Message-ID: <4F2172D4.9090208@lwfinger.net> (sfid-20120126_163556_683684_E5F3E8CD)
Date: Thu, 26 Jan 2012 09:35:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Don deJuan <donjuansjiz@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Realtek rtl8192se in AP mode?
References: <CAP6E9idrT=gu6cnKqMzVMVEXqRHdyuADgBNJTdCebt1Rf1dcfg@mail.gmail.com> <jfoo7s$4n9$1@dough.gmane.org> <4F207641.2090908@lwfinger.net> <jfr3s6$ff7$1@dough.gmane.org> <4F211384.5080105@gmail.com>
In-Reply-To: <4F211384.5080105@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2012 02:49 AM, Don deJuan wrote:
> On 01/26/2012 12:45 AM, Timon ter Braak wrote:
>> On 25/1/12 22:38 , Larry Finger wrote:
>>> If all the Realtek FTP sites fail, please let me know, and I will mail
>>> you the vendor source. I have not attached it here as it is too big for
>>> the ML.
>>
>> I tried all mirrors, even with a proper FTP client; I am just not
>> allowed to connect anonymously. I would appreciate it if you could
>> provide me with the newest driver.
>>
>> I see that you (Larry) are (somewhat) involved in the wireless drivers,
>> noticing some related posts. If needed, I could provide you with
>> some/more test data, regarding this chip.
>
> I would be happy to provide any needed testing/info on this driver as well, I
> have 2 laptops that use this card.

No, I have all the test data that is needed. In AP mode, the kernel driver 
beacons and starts the association process. It does not pass any data packets, 
and cannot complete the authentication. If one tries without encryption, still 
no data throughput.

If you had a way to provide me with more time, I would take it! :)

Larry

