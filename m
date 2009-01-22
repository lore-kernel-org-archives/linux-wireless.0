Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f28.google.com ([209.85.219.28]:60347 "EHLO
	mail-ew0-f28.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZAVPwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 10:52:49 -0500
Received: by ewy9 with SMTP id 9so1706ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 07:52:46 -0800 (PST)
Message-ID: <4978964C.8000301@gmail.com> (sfid-20090122_165254_381895_42FE5537)
Date: Thu, 22 Jan 2009 16:52:44 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <4977785B.7020009@gmail.com> <497806E8.1060709@gmail.com> <200901221609.27401.chunkeey@web.de>
In-Reply-To: <200901221609.27401.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 22 January 2009 06:40:56 Artur Skawina wrote:
> was this with your patch to use rx_refills urb pool for tx, or without?

just your patch plus the fixes that i needed to get it to work, all
of them were in that email. The subject said RFT... ;)
[the line #s were off, because of some extra printks logging the queue len]

artur
