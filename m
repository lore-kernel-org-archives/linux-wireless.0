Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35725 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZHAU3M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 16:29:12 -0400
Subject: Re: [PATCH 2/2] rfkill: Add support for KEY_RFKILL_ALL
From: Bastien Nocera <hadess@hadess.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <1249152859-14769-2-git-send-email-mjg@redhat.com>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com>
	 <1249152859-14769-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 21:25:27 +0100
Message-Id: <1249158328.28327.10654.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-08-01 at 19:54 +0100, Matthew Garrett wrote:
> 
> +               case KEY_RFKILL_ALL:
> +                       rfkill_schedule_toggle(RFKILL_TYPE_WLAN);
> +                       rfkill_schedule_toggle(RFKILL_TYPE_BLUETOOTH);
> +                       rfkill_schedule_toggle(RFKILL_TYPE_UWB);
> +                       rfkill_schedule_toggle(RFKILL_TYPE_WIMAX);
> +                       break;

RFKILL_TYPE_ALL?

