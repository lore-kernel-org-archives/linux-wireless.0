Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:47886 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab2BOKNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:13:22 -0500
Received: by mail-lpp01m010-f48.google.com with SMTP id w12so790069lag.7
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:13:21 -0800 (PST)
Message-ID: <1329300798.19569.37.camel@cumari> (sfid-20120215_111325_819281_3727C308)
Subject: Re: [PATCH] wl12xx: remove unnecessary shadow declaration
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:13:18 +0200
In-Reply-To: <1327401218-1427-1-git-send-email-coelho@ti.com>
References: <1327401218-1427-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-24 at 12:33 +0200, Luciano Coelho wrote: 
> The vif variable was being declared inside one of the internal blocks
> of wl1271_event_process.  This is not necessary, since this variable
> is already declared in the function context.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

