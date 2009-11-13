Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51959 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZKMFdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 00:33:54 -0500
Subject: Re: [PATCH 2/2] rfkill: Add support for KEY_RFKILL
From: Marcel Holtmann <marcel@holtmann.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1252603292-20830-2-git-send-email-mjg@redhat.com>
References: <1252603292-20830-1-git-send-email-mjg@redhat.com>
	 <1252603292-20830-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 06:33:57 +0100
Message-ID: <1258090437.3299.4.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matthew,

> Add support for handling KEY_RFKILL in the rfkill input module. This
> simply toggles the state of all rfkill devices. The comment in rfkill.h
> is also updated to reflect that RFKILL_TYPE_ALL may be used inside the
> kernel.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

looks good and seems to got lost somehow.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


