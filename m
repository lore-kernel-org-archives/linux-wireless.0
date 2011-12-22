Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1LVOLH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 09:11:07 -0500
Date: Thu, 22 Dec 2011 15:11:03 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christian Frost <cf@cfrost.dk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt2800usb poor performance
Message-ID: <20111222141102.GA2261@redhat.com> (sfid-20111222_151117_716109_97AADB6F)
References: <CAA=oPaiE-NAP_rfi3BLv-wM_wBwfLyMh-p2KtMALXPaDG6LxxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAA=oPaiE-NAP_rfi3BLv-wM_wBwfLyMh-p2KtMALXPaDG6LxxA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 22, 2011 at 12:44:17PM +0100, Christian Frost wrote:
> I'm experiencing poor performance with a rt2800usb device when using
> "compat-wireless-3.2-rc6-3" on a 2.6.35 kernel. The bandwidth is
> ~0.5Mbps which I would expect to be significantly higher on a G
> network. Can anyone help with this?

Do you have any better results on older compat wireless version i.e.
3.0 or 3.1. Does disable power save helps (iwconfig wlanX power off)?
Did you try update AP firmware?

Stanislaw
