Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:54591 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab0AFRod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 12:44:33 -0500
MIME-Version: 1.0
In-Reply-To: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 6 Jan 2010 09:44:13 -0800
Message-ID: <43e72e891001060944k28fdfaa7rb5d2325bc5399e6e@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: wireless, fix lock imbalance
To: Jiri Slaby <jslaby@suse.cz>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 6, 2010 at 8:35 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> One fail path in cfg80211_wext_siwscan omits to unlock rdev->mtx.
> Fix that.
>
> Trigerrable by "Scan for SSID" with long enough SSID (> 32).

Cc stable as well?

  Luis
