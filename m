Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45674 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZDVTzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:55:35 -0400
Received: by fxm2 with SMTP id 2so167638fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 12:55:33 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] wl12xx: remove struct platform device
References: <1240371860-9001-1-git-send-email-me@bobcopeland.com>
	<1240371860-9001-3-git-send-email-me@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 22:55:31 +0300
In-Reply-To: <1240371860-9001-3-git-send-email-me@bobcopeland.com> (Bob Copeland's message of "Tue\, 21 Apr 2009 23\:44\:20 -0400")
Message-ID: <87prf4cvkc.fsf@litku.valot.fi> (sfid-20090422_215537_385776_F8034412)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> As far as I can tell this was only for the sysfs file, so now
> that it's gone we can kill the wl12xx_device struct.

Agree, applied.

-- 
Kalle Valo
