Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38949 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490AbbFJT3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 15:29:33 -0400
Received: from [192.168.100.236] (unknown [50.251.239.81])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 466F340A4C5
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 12:29:33 -0700 (PDT)
Message-ID: <5578901C.60502@candelatech.com> (sfid-20150610_212943_327894_FFEA768B)
Date: Wed, 10 Jun 2015 12:29:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Allowing station to over-ride default VHT-oper element?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to figure out how to make a VHT station with hardware capable
of 80Mhz width instead force itself to advertise/use just 40Mhz width,
but still support VHT.

Similar to how the VHT-capabilities overrides works, but for
VHT-operation.

First, is this even a valid thing to do, or does VHT imply
that stations are always available to do 80Mhz?

And second, if it is a valid thing to do, any hints on a
proper way to go about this.  I'm getting a bit tangled in
the code trying to figure out where to apply any overloads
properly.

Possibly in ieee80211_determine_chantype?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

