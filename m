Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33263 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbbBVVb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 16:31:28 -0500
Received: by qcxm20 with SMTP id m20so8431528qcx.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 13:31:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACaajQv0g90p1jKi_v4PAAimhE8EJ+5uY7_B78paZxXSOLn6gA@mail.gmail.com>
References: <CACaajQsqPMzwD=EqdD5_XfWAPmkn-52VVNHF1ntFZ6ofEH4D-w@mail.gmail.com>
 <CACaajQs1r1tE-GXv7cmAL9w8q2cwn_iiDttp6tLFB7BdSBNDPw@mail.gmail.com>
 <54BD2684.30701@broadcom.com> <CACaajQuCfe-POEecGmet7R3GG8sg5KPzdteU+sHD8Vs5TBLzyA@mail.gmail.com>
 <54BE2E98.1030109@broadcom.com> <CACaajQv0g90p1jKi_v4PAAimhE8EJ+5uY7_B78paZxXSOLn6gA@mail.gmail.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Mon, 23 Feb 2015 01:31:12 +0400
Message-ID: <CACaajQtfH92PH4h01NKuih-bfLX3b+OtpEjW-Ox9raoAHte8xw@mail.gmail.com> (sfid-20150222_223132_317195_C5AD39B6)
Subject: Re: b43 bcm43228 and linux 3.18.3
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm switch to 3.19 kernel, now debug info contains:
[  286.557369] b43-phy0 ERROR: PHY transmission error
[  286.557551] b43-phy0 ERROR: PHY transmission error
[  290.412335] b43-phy0 ERROR: PHY transmission error
[  303.809876] b43-phy0 debug: Switching to 5 GHz band
[  303.957855] b43-phy0 debug: Switching to 2.4 GHz band
[  304.296705] b43-phy0 debug: Switching to 5 GHz band
[  304.444641] b43-phy0 debug: Switching to 2.4 GHz band
[  304.784427] b43-phy0 debug: Switching to 5 GHz band
[  304.932492] b43-phy0 debug: Switching to 2.4 GHz band
[  305.273372] b43-phy0 debug: Switching to 5 GHz band
[  305.424327] b43-phy0 debug: Switching to 2.4 GHz band

and i have sometimes stuck in tcp/udp transmissions.

2015-01-20 13:48 GMT+03:00 Vasiliy Tolstov <v.tolstov@selfip.ru>:
> 2015-01-20 13:31 GMT+03:00 Arend van Spriel <arend@broadcom.com>:
>> 'b/g' is in 2.4G band. 'n' is in both 2.4G and 5G band. Assume it can do 'a'
>> as well. Anyway, does that router let you specify the SSID for both 2.4G and
>> 5G. Are you using same SSID for both?
>
>
> As i see i can't specify different SSID for 2.4G and 5G (only one ssid
> available). Does it possible to not roam between bands in b43 driver?
>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov@selfip.ru
> jabber: vase@selfip.ru



-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
