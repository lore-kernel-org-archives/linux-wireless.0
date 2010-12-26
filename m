Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64393 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0LZMoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 07:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <201012261245.29680.rjw@sisk.pl>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com>
 <Pine.LNX.4.44L0.1012252041260.10725-100000@netrider.rowland.org>
 <AANLkTinyKfwcZLD5D4rdF6OpQqr79F==GRjAMBjjbupW@mail.gmail.com> <201012261245.29680.rjw@sisk.pl>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 26 Dec 2010 14:43:39 +0200
Message-ID: <AANLkTimzNXyirnV9wGXf6R454bwEDf=poBZzevAWXEUd@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 26, 2010 at 1:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Why does the driver need the device to be reset even though it hasn't
> been suspeneded yet?

Because it is asked to stop the hardware by mac80211.
