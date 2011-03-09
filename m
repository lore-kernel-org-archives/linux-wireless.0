Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:54861 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1CIKQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 05:16:52 -0500
Message-ID: <4D77539A.90300@pardus.org.tr>
Date: Wed, 09 Mar 2011 12:16:58 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ivdoorn@gmail.com, Johannes Stezenbach <js@sig21.net>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: Unplugging usb wlan (rt73usb) hangs the system
References: <4D6E7B55.6010905@pardus.org.tr> <20110309100651.GA23594@redhat.com>
In-Reply-To: <20110309100651.GA23594@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09.03.2011 12:06, Stanislaw Gruszka wrote:

> 
> I can confirm problem exist in 2.6.37. I can not reproduce it in
> current wireless-testing. I did not investigate further, I guess
> issue is fixed by:
> 
> commit d7bb5f845f437662296adbfeaab8fbfce1c32289
> Author: Johannes Stezenbach <js@sig21.net>
> Date:   Mon Dec 13 12:32:49 2010 +0100
> 
>     rt2x00: fix hang when unplugging USB device in us
> 

Hi, I'll test ASAP and if we confirm that it's the fix, it should be (it
should have been actually with a commit message that serious) CC'ed to
stable@kernel.org.

Thanks!


-- 
Ozan Caglayan

Pardus Linux
http://www.pardus.org.tr/eng
