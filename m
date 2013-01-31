Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3AaPse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:48:34 -0500
Date: Thu, 31 Jan 2013 09:48:22 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 0/7] Improvements to software scanning
Message-ID: <20130131154822.GA28799@thinkpad-t410> (sfid-20130131_164837_427311_8958CC80)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
 <1359644664.8415.68.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359644664.8415.68.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 31, 2013 at 04:04:24PM +0100, Johannes Berg wrote:
> > Second, I attempted to test these patches with iwlwifi (Centrino
> > Advanced-N 6235) to verify that I didn't break anything for drivers with
> > hw scanning. My standard test for this involves running iperf while
> > triggering nearly continuous scans, but I'm seeing lots of problems
> > running a tcp iperf test even with unpatched 3.8-rc4. iperf with udp
> > does fine in either direction. I haven't had time to do any kind of
> > debugging yet, but I thought you'd want to know.
> 
> Hm, ok, thanks.

I just tried moving this card to a different slot in the same machine,
and it's working fine. Hardware problem I guess. Sorry for the false
alarm.

Seth
