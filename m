Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppa03.Princeton.EDU ([128.112.128.214]:54379 "EHLO
	ppa03.princeton.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab2DYF6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 01:58:32 -0400
Received: from csgsmtp201l.Princeton.EDU (csgsmtp201l.Princeton.EDU [128.112.134.60])
	by ppa03.princeton.edu (8.14.4/8.14.4) with ESMTP id q3P5wVu4030104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 01:58:31 -0400
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com [209.85.217.174])
	(authenticated bits=0)
	by csgsmtp201l.Princeton.EDU (8.13.8/8.12.9) with ESMTP id q3P5wUdv030617
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 01:58:31 -0400
Received: by lbbgf7 with SMTP id gf7so1283357lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 22:58:29 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dchyan@princeton.edu
In-Reply-To: <CANUX_P2rzvDCBVLmU2rfaZmUOCMuMDe5=TXE_jwxq4ULrvc=QQ@mail.gmail.com>
References: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
	<CANUX_P1t8XJOka-QGzZSYFHb6MLc7rm4madn059Yg4b6hJB49A@mail.gmail.com>
	<CAOvK7nDO4fS6R5go+ZXYBqyQc8hhbJGun9Weh=-EyX5k11+tXw@mail.gmail.com>
	<CANUX_P2rzvDCBVLmU2rfaZmUOCMuMDe5=TXE_jwxq4ULrvc=QQ@mail.gmail.com>
Date: Wed, 25 Apr 2012 01:58:29 -0400
Message-ID: <CAOvK7nCwRbDNZSnn0EvFMpcQMvX1DmU-tBuFT4kRW1TigwyJDQ@mail.gmail.com> (sfid-20120425_075836_083321_89157EAB)
Subject: Re: iwlwifi bug
From: Daniel Chyan <dchyan@princeton.edu>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct me if I did it incorrectly. I issue "sudo modprobe iwlwifi
debug=0x80000000" but I receive an "Unknown symbol in module, or
unknown parameter" error.

- Daniel

On Wed, Apr 25, 2012 at 1:44 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> + list again
>
> On Wed, Apr 25, 2012 at 08:39, Daniel Chyan <dchyan@princeton.edu> wrote:
>> The warning appears to occur when there are multiple APs. (Under the
>> circumstances, there were some 100 APs.) Going through my kern.log, it
>> looks like there are 9 instances of this warning over the span of 2
>> days. I can try to provide more details around when it occurs if
>> necessary.
>>
>
> ok, can you please run with the module parameter: debug=0x80000000
>
> thanks
