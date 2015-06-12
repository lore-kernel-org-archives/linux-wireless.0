Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:52880 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbbFLSEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 14:04:48 -0400
Received: from [192.168.1.14] (c-73-194-208-34.hsd1.nj.comcast.net [73.194.208.34])
	by smtp.webfaction.com (Postfix) with ESMTP id 43C7E211FF90
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2015 17:43:17 +0000 (UTC)
Message-ID: <557B1A2F.1010608@mindchasers.com> (sfid-20150612_200451_778474_F0F4C860)
Date: Fri, 12 Jun 2015 13:43:11 -0400
From: "Robert E. Cochran" <wifi@mindchasers.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwlwifi in AP mode is experimental?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On wireless.wiki.kernel.org, iwlwifi is listed as experimental for AP Mode.

We have done some basic testing with a 3160 card in AP mode & hostapd 
without issue.  Now we need to determine if it makes sense to ramp up a 
rigorous test plan for it.

Is AP mode with iwlwifi basically a "use at your own risk" scenario?  
Can I expect AP mode to be supported more fully in the future?  Is there 
a particular HW module that does AP mode better than others?  Is there a 
list of missing features?  Are others using iwlwifi for AP mode in a  
product?

Any additional, current information on this will be greatly appreciated.

Thank you,

Bob

