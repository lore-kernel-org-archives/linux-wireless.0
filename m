Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41599 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbaIDRv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 13:51:58 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 193AF40BDE9
	for <linux-wireless@vger.kernel.org>; Thu,  4 Sep 2014 10:51:58 -0700 (PDT)
Message-ID: <5408A6BD.6090304@candelatech.com> (sfid-20140904_195201_728073_99DA3C67)
Date: Thu, 04 Sep 2014 10:51:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Anyone working on making iw able to specify MAC address at station
 creation time?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm having issues with udev renaming newly created stations when I have
udev rules for wlanX, when wlanX is not already existing.

I think specifying MAC on station creation time would solve my problems,
but haven't looked closely yet.

My version of 'iw' doesn't support setting the MAC on creation, from
what I can tel.

Curious if anyone else is working on this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

