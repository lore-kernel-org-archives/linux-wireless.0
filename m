Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43827 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbbAAGw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2015 01:52:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Y6Zcq-0007Ro-T9
	for linux-wireless@vger.kernel.org; Thu, 01 Jan 2015 07:52:53 +0100
Received: from cpe-67-11-235-53.satx.res.rr.com ([67.11.235.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jan 2015 07:52:52 +0100
Received: from chrischavez by cpe-67-11-235-53.satx.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jan 2015 07:52:52 +0100
To: linux-wireless@vger.kernel.org
From: Christopher Chavez <chrischavez@gmx.us>
Subject: Re: p54usb kernel panic on recent mainline kernels
Date: Thu, 1 Jan 2015 06:52:37 +0000 (UTC)
Message-ID: <loom.20150101T051652-786@post.gmane.org> (sfid-20150101_075316_149054_109903E7)
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com> <loom.20141227T010207-869@post.gmane.org> <2296382.VCr2c4tJc9@debian64> <5946673.YueIgFzjsn@debian64> <549EFC9F.9030504@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:
 
> I think this needs to be applied to 3.{17-19}.

I finally tested the patch on 3.18.1, and it works. It would be nice to have 
this available in 3.17 and 3.18 -stable.

Tested-by: Christopher Chavez <chrischavez@gmx.us>

nohwcrypt=1 also worked.

Thanks

