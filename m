Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:64961 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866AbZFKDvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 23:51:54 -0400
Received: by an-out-0708.google.com with SMTP id d40so2256320and.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 20:51:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890906102008u421f5669m3cf23a437f63d278@mail.gmail.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	<f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	<3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	<69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	<3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
	<1244619027.18481.55.camel@johannes.local> <3ace41890906100639gb800904td06d86efef90e656@mail.gmail.com>
	<69e28c910906100822q6eae8b29p2381220b23b4f4b1@mail.gmail.com>
	<1244648968.4178.5.camel@johannes.local> <3ace41890906102008u421f5669m3cf23a437f63d278@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Jun 2009 20:51:36 -0700
Message-ID: <43e72e890906102051l2169e91dvc2c2c8406eb61144@mail.gmail.com>
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 8:08 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> 2009/6/10 Johannes Berg <johannes@sipsolutions.net>:
>
>> Now, it may or may not be possible to work around this in software by
>> sending out the multicast frames on a high-priority queue right after
>> the beacon, or something like that, but frankly I'm not interested in
>> working on zd1211rw myself, so that will have to be somebody who is (a)
>> familiar with 802.11 powersaving and multicast buffering, (b) wants
>> zd1211rw to work, and finally (c) has a lot of time to play with the
>> device.
>
> For the sake of being pedantic, can I have some reference (if only for
> those sleepless nights for lack of boring reading materials...)? Maybe
>  I won't understand it anyway, but maybe somebody else who is
> listening in to this exchange can chip in.
> I have a 1300-page pdf supposedly the  802.11 2007 standard I
> downloaded some months ago through one of the wikipedia links, I think
> (somewhere under http://standards.ieee.org/) ... chapter 11 is MLME
> and section 11.2 is power management, which in turn is split into two
> sub-sections about power management in infrastructure nework and IBSS
> mode. I found a particular sentence in section 11.2.1. which sounds a
> bit like what you are saying (except with some cryptic acronyms!):
>
> ------
> If any STA in its BSS is in PSmode, the AP shall buffer all broadcast
> and multicast MSDUs and deliver them to all STAs immediately
> following the next Beacon frame containing a DTIM transmission.
> ------
>
> Have I found the right place to read up on such things, or there are
> other documents, etc (more detailed, or more "layman")?

This might be helpful:

http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-savings

  Luis
