Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:64766 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZFYOFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 10:05:11 -0400
Received: by fg-out-1718.google.com with SMTP id e21so283727fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2009 07:05:12 -0700 (PDT)
Date: Thu, 25 Jun 2009 10:36:36 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: kernel crashes, 2.6.30, rt2x00, ath5k, ieee80211_get_*_rate,
	automatic rate control
Message-ID: <20090625083636.GA6323@linux-m68k.org>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20090623202541.GA3635@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2009 at 04:25:41PM -0400, Bob Copeland wrote:

> 
> The patch should already be on the way to stable, but I'll check on it.

thanks, you certainly have my vote that it should get into 2.6.30.*

On an unrelated note, the ath5k device is in a netbook with an wifi LED and
Fn-F2 hotkey to toggle wlan.

The hotkey works, the LED not. What do I need to make the LED working on the 
device?

Also, while the hotkey works how do query the current on/off status of it 
in Linux?

Richard

