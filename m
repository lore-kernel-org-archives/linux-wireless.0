Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37724 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJWQxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 12:53:11 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 4FFF740AB7C
	for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 09:53:10 -0700 (PDT)
Message-ID: <54493276.4030007@candelatech.com> (sfid-20141023_185314_774672_09890850)
Date: Thu, 23 Oct 2014 09:53:10 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211-hwsim question
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From what I can tell, when hwsim sends frames to wmediumd using netlink sockets,
it does not include any channel/frequency information in the netlink packet.

Any reason not to add that?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

