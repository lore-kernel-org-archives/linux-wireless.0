Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:40149 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab0BQUul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 15:50:41 -0500
Date: Wed, 17 Feb 2010 20:50:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"marcel@holtmann.org" <marcel@holtmann.org>
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20100217205037.GB26306@srcf.ucam.org>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com> <20100217052247.GD7160@core.coreip.homeip.net> <20100217180342.GA22522@srcf.ucam.org> <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com> <20100217191708.GA15554@core.coreip.homeip.net> <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com> <20100217195435.GA15742@core.coreip.homeip.net> <20100217200233.GA24976@srcf.ucam.org> <446821D4-8E9D-4701-9A50-04738C5733B6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <446821D4-8E9D-4701-9A50-04738C5733B6@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 12:49:14PM -0800, Dmitry Torokhov wrote:
> On Feb 17, 2010, at 12:02 PM, Matthew Garrett <mjg59@srcf.ucam.org>  
> wrote:
>> KEY_BATTERY is heavily used in userspace. I think all the hardware  
>> that
>> generates it does so via i8042 rather than a platform driver, so it
>> wouldn't show up in the kernel.
>>
>
> Ah, I see. I hope the keycode is not used to signal battery status  
> change but to invoke battery/power manager applet...

Correct. On Gnome, at least, it pops up a dialog with the current 
battery state.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
