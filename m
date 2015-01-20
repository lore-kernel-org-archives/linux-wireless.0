Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:37990 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbATKbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:31:55 -0500
Message-ID: <54BE2E98.1030109@broadcom.com> (sfid-20150120_113158_442768_E9578571)
Date: Tue, 20 Jan 2015 11:31:52 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
CC: <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 bcm43228 and linux 3.18.3
References: <CACaajQsqPMzwD=EqdD5_XfWAPmkn-52VVNHF1ntFZ6ofEH4D-w@mail.gmail.com> <CACaajQs1r1tE-GXv7cmAL9w8q2cwn_iiDttp6tLFB7BdSBNDPw@mail.gmail.com> <54BD2684.30701@broadcom.com> <CACaajQuCfe-POEecGmet7R3GG8sg5KPzdteU+sHD8Vs5TBLzyA@mail.gmail.com>
In-Reply-To: <CACaajQuCfe-POEecGmet7R3GG8sg5KPzdteU+sHD8Vs5TBLzyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/15 11:24, Vasiliy Tolstov wrote:
> 2015-01-19 18:45 GMT+03:00 Arend van Spriel<arend@broadcom.com>:
>> What do you mean by "moved from 5Ghz to 2.4Ghz..". You mean it is roaming
>> between the two bands?
>
> Yes, i have zyxel keenetic start that supports b/g/n

'b/g' is in 2.4G band. 'n' is in both 2.4G and 5G band. Assume it can do 
'a' as well. Anyway, does that router let you specify the SSID for both 
2.4G and 5G. Are you using same SSID for both?

Regards,
Arend

>> Anyway, there is a b43 specific mailing list which I
>> added.
>
>
> Thanks. I don't know about this list.
>

