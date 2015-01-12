Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:39817 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbbALG4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 01:56:03 -0500
Received: by mail-ig0-f180.google.com with SMTP id h15so10249704igd.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 22:56:02 -0800 (PST)
Date: Mon, 12 Jan 2015 01:54:45 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Hong Xu <hong@topbug.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Add a module parameter to disable blink
Message-ID: <20150112065445.GB29484@localhost> (sfid-20150112_075607_006427_29606D94)
References: <1420968029-1222-1-git-send-email-hong@topbug.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420968029-1222-1-git-send-email-hong@topbug.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 11, 2015 at 01:20:29AM -0800, Hong Xu wrote:
> Add an option "blink" to enable or disable the LED blink. The default
> value is set to 1 so that existing users would not experience any
> unexpected changes.

Been a while since I looked, but isn't there a way to achieve same
result by just echoing 'none' into the relevant LED's sysfs file
(something like /sys/class/leds/phy0-led/trigger)?

-- 
Bob Copeland %% http://bobcopeland.com/
