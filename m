Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:19130 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab0KZIO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 03:14:57 -0500
Subject: Re: [PATCH 00/18] AP mode support for wl12xx
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290079951-16793-1-git-send-email-arik@wizery.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 10:15:15 +0200
Message-ID: <1290759315.15341.2.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arik,

On Thu, 2010-11-18 at 13:32 +0200, ext Arik Nemtsov wrote:
> These patches add access point mode support to the wl12xx driver.
> This mode uses a separate firmware and has a different initialization
> sequence.
> 
> In all instances, the flow has been split according to the operating
> mode of the driver (AP/STA), so as not to affect STA mode functionality.

Unfortunately I didn't have much time to look into your AP patches yet.
We need to review this very carefully.  It touches so many parts of the
code that I'm a bit worried that this would break normal STA
functionality.

How well have you tested these patches in STA mode? Do you think there
would be any possibility of making this Kconfigurable so that there
would be no (or very little) binary difference in the code if AP is not
enabled?

-- 
Cheers,
Luca.

