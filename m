Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:5463 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbZKDPQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 10:16:09 -0500
Message-ID: <4AF19AB8.8040507@lwfinger.net>
Date: Wed, 04 Nov 2009 09:16:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Paulius Zaleckas <paulius.zaleckas@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] usb: Check results of dma_map_single
References: <4af115c3.JUDAYfcydqPYCYyH%Larry.Finger@lwfinger.net> <4AF17884.5000200@gmail.com> <4AF18A61.20909@lwfinger.net> <200911041551.52914.mb@bu3sch.de>
In-Reply-To: <200911041551.52914.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2009 08:51 AM, Michael Buesch wrote:
> On Wednesday 04 November 2009 15:06:25 Larry Finger wrote:
>> Thank you for your review and comments. I'll wait a bit to see what
>> other comments are offered, but I have implemented all your changes.
> 
> If you use a WARN_ON, please use WARN_ON_ONCE to avoid possible spamming of the logs.

Good point.

Larry
