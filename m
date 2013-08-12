Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39140 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab3HLXhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 19:37:32 -0400
Received: by mail-oa0-f53.google.com with SMTP id k18so10652216oag.12
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 16:37:31 -0700 (PDT)
Message-ID: <520971BA.6040503@lwfinger.net> (sfid-20130813_013735_685003_B247B22A)
Date: Mon, 12 Aug 2013 18:37:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Colleen Josephson <cjoseph@mit.edu>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: issues with RTL8188CE device and rtl8192ce driver
References: <CAN3-2D7=P=9VyV7xoANw_6B8VhOaTRC1iMw+mwUH2-g8YOmPMg@mail.gmail.com> <520968B0.80301@lwfinger.net> <CAN3-2D5rCnXYogA6s6in_e6qpyLmZ0bpbGX=REi=Cn29U40nMw@mail.gmail.com>
In-Reply-To: <CAN3-2D5rCnXYogA6s6in_e6qpyLmZ0bpbGX=REi=Cn29U40nMw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2013 06:27 PM, Colleen Josephson wrote:
>> Have you tried the backports driver? There are a number of changes since
>> 3.8, which you will access that way.
>
> I had not tried the backports driver. Do I need remove support things
> in my kernel that I am now compiling with backports?

If you install the baclports drivers, they will replace the standard ones.

Larry


