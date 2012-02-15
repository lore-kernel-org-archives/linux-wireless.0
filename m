Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:60262 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496Ab2BOKR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:17:59 -0500
Received: by mail-lpp01m010-f47.google.com with SMTP id c1so1093045lah.34
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:17:58 -0800 (PST)
Message-ID: <1329301074.19569.42.camel@cumari> (sfid-20120215_111807_348841_1CC21334)
Subject: Re: [PATCH v3 0/4] wl12xx: add some psm/suspend features
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:17:54 +0200
In-Reply-To: <1328177022-26646-1-git-send-email-eliad@wizery.com>
References: <1328177022-26646-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 12:03 +0200, Eliad Peller wrote: 
> Add some psm / suspend features:
> * Add the ability to force psm (by default, the fw uses dynamic ps)
> * Use differnet wake up conditions on suspend
> 
> (depends on the "wl12xx: update fw api" patchset)
> 
> v3: remove the rx-filters patches
> 
> Eyal Shapira (4):
>   wl12xx: Set different wake up conditions in case of suspend
>   wl12xx: add suspend_listen_interval debugfs file
>   wl12xx: add forced_ps mode
>   wl12xx: add forced_ps debugfs file

Applied the set with v4 of 3/4.

-- 
Cheers,
Luca.

