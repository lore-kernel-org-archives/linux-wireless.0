Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55390 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab1CRQPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 12:15:05 -0400
Received: by qwk3 with SMTP id 3so2925833qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 09:15:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103181642.28386.helmut.schaa@googlemail.com>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
	<201103172107.25316.helmut.schaa@googlemail.com>
	<AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
	<201103181642.28386.helmut.schaa@googlemail.com>
Date: Fri, 18 Mar 2011 17:15:04 +0100
Message-ID: <AANLkTi=oAQ1M=XmFpyjh+2zkHidN_AdG7880A=TGsM-h@mail.gmail.com>
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in
 AP and IBSS
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Juan Carlos Garza <juancarlosgarza@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Johannes Stezenbach <js@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Mar 18, 2011 at 4:42 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Thanks for testing Juan.
>
> Am Freitag, 18. März 2011 schrieb Juan Carlos Garza:
>> I applied the patches (manually), and tested the stick.
>>
>> The transfer of big loads now is successful.
>
> Ivo, Johannes, are there any issues left with the async tx status
> patches for rt2800usb (in the experimental branch) as they seem to
> lower the chance for missed tx status reports.

I have to do a performance test to see if there are any issues remaining,
but so far all those patches resulted in poorer performance (reduced
association successes).

Ivo
