Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f197.google.com ([209.85.211.197]:61641 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0BQUz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 15:55:29 -0500
Received: by ywh35 with SMTP id 35so298652ywh.4
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 12:55:27 -0800 (PST)
References: <1266356185-10324-1-git-send-email-mjg@redhat.com> <20100217052247.GD7160@core.coreip.homeip.net> <20100217180342.GA22522@srcf.ucam.org> <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com> <20100217191708.GA15554@core.coreip.homeip.net> <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com> <20100217195435.GA15742@core.coreip.homeip.net> <20100217200233.GA24976@srcf.ucam.org>
Message-Id: <446821D4-8E9D-4701-9A50-04738C5733B6@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20100217200233.GA24976@srcf.ucam.org>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Date: Wed, 17 Feb 2010 12:49:14 -0800
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"marcel@holtmann.org" <marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 17, 2010, at 12:02 PM, Matthew Garrett <mjg59@srcf.ucam.org>  
wrote:

> On Wed, Feb 17, 2010 at 11:54:35AM -0800, Dmitry Torokhov wrote:
>
>> Is there anything currently in works that would make use of this  
>> button?
>> I do not want to allocate keycode "for the future" which may never  
>> come.
>> We did it with KEY_BATTERY but I do not think anyone actually uses  
>> it.
>
> KEY_BATTERY is heavily used in userspace. I think all the hardware  
> that
> generates it does so via i8042 rather than a platform driver, so it
> wouldn't show up in the kernel.
>

Ah, I see. I hope the keycode is not used to signal battery status  
change but to invoke battery/power manager applet...

-- 
Dmitry

