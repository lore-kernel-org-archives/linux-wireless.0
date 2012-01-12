Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38135 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab2ALHlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 02:41:37 -0500
Received: by lags15 with SMTP id s15so805276lag.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 23:41:34 -0800 (PST)
Subject: Re: [PATCH v2] wl12xx: implement sta_state callback
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1325162958-8515-1-git-send-email-eliad@wizery.com>
References: <1325162958-8515-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 09:41:30 +0200
Message-ID: <1326354090.32758.15.camel@cumari> (sfid-20120112_084140_338744_E6C28AB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-29 at 14:49 +0200, Eliad Peller wrote: 
> Update the fw regarding peer state and ht caps
> only after the station was authorized.
> 
> Otherwise, the fw might try establishing BA session
> before the sta is authorized.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> depends on "notify driver about changes in station state" patchset

Dropping this for now, since this will need to be updated according to
the on-going changes in the state API.

-- 
Cheers,
Luca.

