Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35313 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZIXEB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 00:01:29 -0400
Date: Wed, 23 Sep 2009 23:54:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless-testing broken
Message-ID: <20090924035356.GC2726@tuxdriver.com>
References: <da94abde0909231800v75b05677ka6b8570a73b6055c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <da94abde0909231800v75b05677ka6b8570a73b6055c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 06:00:41PM -0700, Kalle Valo wrote:
> Hi,
> 
> I upgraded to latest wireless-testing and noticed that I can't connect
> anymore with my iwl3945. master-2009-09-16 still works. My syslog has
> this:
> 
> Sep 24 03:53:28 tikku kernel: [  719.479190] phy0: device no longer
> idle - scanning
> Sep 24 03:53:31 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
> Sep 24 03:53:31 tikku wpa_supplicant[12381]: Trying to associate with
> 00:03:52:d9:27:10 (SSID='ibahn' freq=2452 MHz)

Kalle,

I know you aren't in a great situation for this, but could you try
a bisect?  Or, you might just try reverting "iwlwifi: reduce noise
when skb allocation" as a start...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
