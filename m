Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34735 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbbATKsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:48:19 -0500
Received: by mail-qg0-f44.google.com with SMTP id l89so20030138qgf.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 02:48:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54BE2E98.1030109@broadcom.com>
References: <CACaajQsqPMzwD=EqdD5_XfWAPmkn-52VVNHF1ntFZ6ofEH4D-w@mail.gmail.com>
 <CACaajQs1r1tE-GXv7cmAL9w8q2cwn_iiDttp6tLFB7BdSBNDPw@mail.gmail.com>
 <54BD2684.30701@broadcom.com> <CACaajQuCfe-POEecGmet7R3GG8sg5KPzdteU+sHD8Vs5TBLzyA@mail.gmail.com>
 <54BE2E98.1030109@broadcom.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Tue, 20 Jan 2015 14:48:03 +0400
Message-ID: <CACaajQv0g90p1jKi_v4PAAimhE8EJ+5uY7_B78paZxXSOLn6gA@mail.gmail.com> (sfid-20150120_114827_816708_6E6B8CCC)
Subject: Re: b43 bcm43228 and linux 3.18.3
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-20 13:31 GMT+03:00 Arend van Spriel <arend@broadcom.com>:
> 'b/g' is in 2.4G band. 'n' is in both 2.4G and 5G band. Assume it can do 'a'
> as well. Anyway, does that router let you specify the SSID for both 2.4G and
> 5G. Are you using same SSID for both?


As i see i can't specify different SSID for 2.4G and 5G (only one ssid
available). Does it possible to not roam between bands in b43 driver?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
