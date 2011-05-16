Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62551 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1EPTxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 15:53:35 -0400
Received: by iwn34 with SMTP id 34so4216860iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 12:53:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimDudEKPEjTrWxm1wNA00Cmyot+sA@mail.gmail.com>
References: <BANLkTimDudEKPEjTrWxm1wNA00Cmyot+sA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 16 May 2011 12:53:15 -0700
Message-ID: <BANLkTi=cx1CJkuBgvKkd9tm1u2hu7WGYYA@mail.gmail.com> (sfid-20110516_215342_556360_1D53C691)
Subject: Re: what dictates the firmware directory of compat-wireless firmware?
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 16, 2011 at 12:41 PM, George Nychis <gnychis@gmail.com> wrote:

> So, I'm a little confused why it is not finding the firmware.  Does
> anyone have any insight on this?

compat-wireless uses a new module called compat_firmware so you need a
respective new udev rule for it, it uses the same path for firmware
though so you just need to slap on the right udev rule.

  Luis
