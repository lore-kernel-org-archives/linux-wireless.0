Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37313 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1CCFVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 00:21:17 -0500
Received: by wyg36 with SMTP id 36so724082wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 21:21:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110302163051.425d1419@toddler>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
	<20110225165745.4860afe0@realh.co.uk>
	<20110226183542.75bc1786@realh.co.uk>
	<AANLkTi=ZWmWZWMBSdGX8S9EfiRyv3eKEU9P3n0bfDAuJ@mail.gmail.com>
	<20110302163051.425d1419@toddler>
Date: Thu, 3 Mar 2011 10:51:15 +0530
Message-ID: <AANLkTinEA2NVxwWZJME-oChE6OEJc_TSTajMfe7f+3hm@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tony Houghton <h@realh.co.uk>
Cc: Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil@venema.h4ckr.net, Vivek Natarajan <vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 2, 2011 at 10:00 PM, Tony Houghton <h@realh.co.uk> wrote:
> On Mon, 28 Feb 2011 11:06:54 +0530
> Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>
>> On Sun, Feb 27, 2011 at 12:05 AM, Tony Houghton <h@realh.co.uk> wrote:
>> > I tried to reconfigure rsyslog to sync on each message but it
>> > didn't log anything useful :-(.
>>
>> I will try to reproduce here with my platform.
>
> Is this still not reproducible? I'd like to do more to help trace the
> problem but I'm a bit stuck. Is there something I can do to make sure
> all the debug/log messages from ath9k appear on the console?

sudo dmesg -n 8?

>
> I'm using rsyslog ATM, which is Debian's default logger AFAIK, but I'm
> willing to install something different if it will help capture these
> messages.

Tony, it looks like we are not having the card you are using. Any way
I will try to recreate the issue with the AR9285 card I have.

>
