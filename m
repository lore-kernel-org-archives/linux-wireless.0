Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36959 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1JOOSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 10:18:38 -0400
Received: by iaek3 with SMTP id k3so3872095iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 07:18:37 -0700 (PDT)
Message-ID: <4E999645.2070800@lwfinger.net> (sfid-20111015_161845_399707_93739235)
Date: Sat, 15 Oct 2011 09:18:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: Arend van Spriel <arend@broadcom.com>,
	Pavel Roskin <proski@gnu.org>,
	John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net> <20111014111103.5658d4aa@mj> <4E986392.7020008@lwfinger.net> <4E9943D5.1060607@broadcom.com> <4E998AA1.4080907@lwfinger.net> <20111015155306.6bd1e695@milhouse>
In-Reply-To: <20111015155306.6bd1e695@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2011 08:53 AM, Michael Büsch wrote:
> On Sat, 15 Oct 2011 08:29:05 -0500
> Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>
>>> I plan to fill the buffer using 8-bit reads from SPROM,
>
>> That sounds like a good plan. When that is posted, I'll study if that kind of
>> change makes sense for ssb.
>
> If this change is made, it has to be tested on all supported devices, IMO.
> I would not be surprised if there are older devices that don't like that.

Two of my devices are a BCM4303 (14e4:4301), and an early BCM4306. There are not 
likely to be any older than that.

Larry
