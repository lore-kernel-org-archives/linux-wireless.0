Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53332 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbbAEJdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 04:33:44 -0500
Message-ID: <1420450414.1898.6.camel@sipsolutions.net> (sfid-20150105_103346_829868_35973638)
Subject: Re: p54usb kernel panic on recent mainline kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Christopher Chavez <chrischavez@gmx.us>,
	linux-wireless@vger.kernel.org
Date: Mon, 05 Jan 2015 10:33:34 +0100
In-Reply-To: <549EFC9F.9030504@lwfinger.net> (sfid-20141227_193826_833900_3E3C56C2)
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com>
	 <loom.20141227T010207-869@post.gmane.org> <2296382.VCr2c4tJc9@debian64>
	 <5946673.YueIgFzjsn@debian64> <549EFC9F.9030504@lwfinger.net>
	 (sfid-20141227_193826_833900_3E3C56C2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-12-27 at 12:38 -0600, Larry Finger wrote:

> I had redone the bisection and found that ca34e3b was the bad commit. That was 
> late last night (CST - UTC-5). I was pleased to find your patch in my mailbox 
> this morning.
> 
> With your patch, my system has survived for about 2 hours, whereas it would have 
> failed in 2 minutes or less. You can add
> 
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> I think this needs to be applied to 3.{17-19}.

Thanks everyone. I just sent out a revert - that'll be easier to manage
for 3.17-3.19, and we can redo the original commit properly for 3.20.

johannes

