Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54622 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1CEJP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 04:15:29 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=fRXHWVeZpR1X5pGAZjPGTt84ZPo1kWkPQhZps@mail.gmail.com>
References: <1299076306-11955-1-git-send-email-geryk@ti.com>
 <AANLkTik5Z_eAA_qWGB_rwoK3P1g4jMnM6hj26fje6JHf@mail.gmail.com>
 <AANLkTimkoaZqn9SDEuc=vuazzqwA7Jrmz1hiwDWSXhM2@mail.gmail.com> <AANLkTi=fRXHWVeZpR1X5pGAZjPGTt84ZPo1kWkPQhZps@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 5 Mar 2011 11:15:09 +0200
Message-ID: <AANLkTin3UcHeJeRmjUYNNyHFitjv5GNg51uxm=63wtDG@mail.gmail.com>
Subject: Re: [PATCH v2] linux-firmware: Initial release for Bluetooth init script
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: Gery Kahn <gery.kahn@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 5, 2011 at 10:17 AM, Pavan Savoy <pavan_savoy@ti.com> wrote:
> So, yes in case the firmware is going to be freely available from
> now-onwards - will post a patch to expect smaller case file name.

Well, right now we have users of st_kim, and we prefer using the
firmware name that is currently expected by it. Otherwise it just
won't work..

I understand the the lower case affinity, but that's second to not
breaking the user experience IMHO.

Thanks,
Ohad.
