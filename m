Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34075 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbbJ2G7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 02:59:33 -0400
Received: by oies66 with SMTP id s66so20678818oie.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 23:59:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGHP0pJEnqvkRgtVprGxBqOd_c9m-ybE9L_9zAtJS=c7=LbckQ@mail.gmail.com>
References: <CAGHP0pK5452ixOHr0uWY=o2S2JvgoqVx8X7r6ZnQ=ezxqNg1UA@mail.gmail.com>
 <d866527bb2404c9f895960173159744a@SC-EXCH04.marvell.com> <CAGHP0pJEnqvkRgtVprGxBqOd_c9m-ybE9L_9zAtJS=c7=LbckQ@mail.gmail.com>
From: Chris Kuethe <chris.kuethe@gmail.com>
Date: Wed, 28 Oct 2015 23:59:13 -0700
Message-ID: <CAGHP0pLVvi9Q_4__QF4pZx-=HYW7bzmYbd6w6sS7RWcoRPqpfw@mail.gmail.com> (sfid-20151029_075955_082139_28F6F41B)
Subject: Re: problems with mwifiex_usb, hangs under load, firmware in bad state
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2015 at 12:13 PM, Chris Kuethe <chris.kuethe@gmail.com> wrote:
>> Also, share if there is any definite procedure so that we can try to recreate the issue at our end.
>
> My test is simply to run some big wgets in a loop and wait for the
> errors. Sometimes it happens after a few hundred MB, sometimes after a
> few GB.

Another data point: If the firmware crashes on a 2.4GHz network, I can
switch to 5Ghz (or vice versa) and use it again ... once.

-- 
GDB has a 'break' feature; why doesn't it have 'fix' too?
