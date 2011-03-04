Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34842 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759948Ab1CDXej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 18:34:39 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik5Z_eAA_qWGB_rwoK3P1g4jMnM6hj26fje6JHf@mail.gmail.com>
References: <1299076306-11955-1-git-send-email-geryk@ti.com> <AANLkTik5Z_eAA_qWGB_rwoK3P1g4jMnM6hj26fje6JHf@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 5 Mar 2011 01:34:19 +0200
Message-ID: <AANLkTimkoaZqn9SDEuc=vuazzqwA7Jrmz1hiwDWSXhM2@mail.gmail.com>
Subject: Re: [PATCH v2] linux-firmware: Initial release for Bluetooth init script
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: Gery Kahn <gery.kahn@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavan,

On Thu, Mar 3, 2011 at 3:44 PM, Pavan Savoy <pavan_savoy@ti.com> wrote:
> On Wed, Mar 2, 2011 at 8:01 PM, Gery Kahn <gery.kahn@gmail.com> wrote:
...
> Can we name this in all smaller case?

How is this going to work with smaller case ?

AFAICS, Gery used the exact name format that st_kim is looking for:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/misc/ti-st/st_kim.c;h=73b6c8b0e8696db9dbe8a71590bf7b62fb3b5532;hb=HEAD#l261

Do you plan to change st_kim ?

If so, please first change it, and then update the firmware file.

Thanks,
Ohad.
