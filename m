Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:43232 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759900AbXHAL4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 07:56:41 -0400
Message-ID: <46B074F4.9060902@lwfinger.net>
Date: Wed, 01 Aug 2007 06:56:36 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: David Woodhouse <dwmw2@infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH final] softmac: Fix deadlock of wx_set_essid with assoc  work
References: <200707312041.04987.mb@bu3sch.de> <1185965301.3083.145.camel@pmac.infradead.org> <200708011251.17320.mb@bu3sch.de>
In-Reply-To: <200708011251.17320.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 01 August 2007, David Woodhouse wrote:
>> On Tue, 2007-07-31 at 20:41 +0200, Michael Buesch wrote:
>>> David, please stresstest this.
>> It seemed to survive being left with NetworkManager overnight, which the
>> 2.6.22.1 kernel was consistently failing to cope with beforehand.
> 
> So John, please apply this.

ACK.

Larry
