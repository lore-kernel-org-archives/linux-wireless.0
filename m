Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:47943 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0BQUCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 15:02:36 -0500
Date: Wed, 17 Feb 2010 20:02:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-input@vger.kernel.org, marcel@holtmann.org
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20100217200233.GA24976@srcf.ucam.org>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com> <20100217052247.GD7160@core.coreip.homeip.net> <20100217180342.GA22522@srcf.ucam.org> <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com> <20100217191708.GA15554@core.coreip.homeip.net> <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com> <20100217195435.GA15742@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100217195435.GA15742@core.coreip.homeip.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 11:54:35AM -0800, Dmitry Torokhov wrote:

> Is there anything currently in works that would make use of this button?
> I do not want to allocate keycode "for the future" which may never come.
> We did it with KEY_BATTERY but I do not think anyone actually uses it.

KEY_BATTERY is heavily used in userspace. I think all the hardware that 
generates it does so via i8042 rather than a platform driver, so it 
wouldn't show up in the kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
