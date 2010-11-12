Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52583 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab0KLOOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 09:14:21 -0500
Received: by yxn35 with SMTP id 35so15558yxn.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 06:14:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289509738.3695.7.camel@jlt3.sipsolutions.net>
References: <AANLkTinDJxnMHEbQjUwWjT2MnW5r7gcxoZW7bZetT7a9@mail.gmail.com>
 <1289497988.3695.3.camel@jlt3.sipsolutions.net> <AANLkTikL5VCadteiDCfDeA5VL8kdofM1rN1gBKmUbG9O@mail.gmail.com>
 <1289509738.3695.7.camel@jlt3.sipsolutions.net>
From: Cassiano Tartari <cassianotartari@gmail.com>
Date: Fri, 12 Nov 2010 12:13:58 -0200
Message-ID: <AANLkTimY1p+Jcc4jXL6LJnNgaQ1KwcSNUApe-GSRHVB-@mail.gmail.com>
Subject: Re: Overload Probe Request to send data
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

@johannes

I tryed to find some information about how to overload the Vendor
Specific Action frame.

But I only found:

VSA frame - vendor specific action frame
- stand-alone management frame
- doesn't contain timestamp
- no segmentation required (max MMPDU)

I don't know if I used the correct works, but I tryed: "vendor
specific action frame" 802.11 on my researchs.

And a little more information at IEEE Std 802.11 pdf on page 151.

I'm studying the protocol.


On Thu, Nov 11, 2010 at 7:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Thu, 2010-11-11 at 17:18 -0200, Cassiano Tartari wrote:
> > Sorry johannes, but I didn't understand what you said.
> >
> > I need to send data without confiability, just in one way client->AP
> > and without association, and this information is too short.
>
> Oh ... and why not use vendor specific public action frames?
>
> johannes
>

-
Cassiano Valle Tartari
Computer Engineer

Tel: +55.48.84474818
Email: falecom@cassianotartari.eng.br
Site: http://www.cassianotartari.eng.br
