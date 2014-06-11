Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:48393 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaFKXxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 19:53:44 -0400
Received: by mail-oa0-f54.google.com with SMTP id eb12so559976oac.27
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 16:53:43 -0700 (PDT)
Message-ID: <5398EC04.2090108@lwfinger.net> (sfid-20140612_015347_992911_DDBB8158)
Date: Wed, 11 Jun 2014 18:53:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James Cameron <quozl@laptop.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: Linux 3.15: WLAN regression on WRL54GL/B43?
References: <20140611230513.GC913@drone.musicnaut.iki.fi> <20140611233407.GA13823@us.netrek.org>
In-Reply-To: <20140611233407.GA13823@us.netrek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2014 06:34 PM, James Cameron wrote:
> Check that the driver reports the channel the probe was heard on?
>
> Another driver hit this and was fixed:
>
> 	at76c50x: fix scan does not work with latest mac80211
>

It would also be helpful to report what device you have as shown by 'lspci -nn'. 
This problem does not occur with my BCM4312 with PCI ID 14e4:4315.

Larry

