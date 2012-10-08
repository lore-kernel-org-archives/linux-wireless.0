Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab2JHMXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 08:23:53 -0400
Date: Mon, 8 Oct 2012 14:22:14 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt73usb: WARN(x) in check_sdata_in_driver() again
Message-ID: <20121008122213.GA4504@redhat.com> (sfid-20121008_142357_601804_FFEA3996)
References: <CANq1E4QzhnVwk1Tt3JAK7Qgp=LbMuS58xd6i147Nvjts0MkmwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANq1E4QzhnVwk1Tt3JAK7Qgp=LbMuS58xd6i147Nvjts0MkmwQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 20, 2012 at 12:55:57PM +0200, David Herrmann wrote:
> I reported this earlier this year:
> http://www.spinics.net/lists/linux-wireless/msg94318.html
> I now run kernel 3.5.3 and still get the warnings. dmesg is attached.

W track this in 
https://bugzilla.kernel.org/show_bug.cgi?id=48041

Feel free to CC yourself to that bugzilla. I treat this bug as
different from your previous report since now wifi connection 
do not break.

Thanks
Stanislaw

