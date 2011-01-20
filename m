Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32891 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab1ATPrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 10:47:52 -0500
Received: by eye27 with SMTP id 27so313667eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 07:47:51 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Subject: Re: iwl4965: 11n broken
Date: Thu, 20 Jan 2011 16:46:21 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <201101201242.24680.helmut.schaa@googlemail.com> <1295537707.21281.1.camel@wwguy-ubuntu>
In-Reply-To: <1295537707.21281.1.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101201646.21583.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 20. Januar 2011 schrieb Guy, Wey-Yi:
> Sorry for the mistake, here I attach the patch to address this issue.
> Please give a try to see if it fix it, I will also push this patch
> upstream if works for you.

Sure, works fine. Feel free to add a

Tested-by: Helmut Schaa <helmut.schaa@googlemail.com>

to the patch when submitting.

Thanks,
Helmut
