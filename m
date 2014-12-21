Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46870 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaLUOTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 09:19:39 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so4268753pab.35
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 06:19:38 -0800 (PST)
Message-ID: <5496D6F6.6050001@gmail.com> (sfid-20141221_151944_866890_844D8386)
Date: Sun, 21 Dec 2014 22:19:34 +0800
From: Fred Chou <fred.chou.nd@gmail.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix dot11MulticastTransmittedFrameCount tested
 address
References: <1419168328-6114-1-git-send-email-eliad@wizery.com>
In-Reply-To: <1419168328-6114-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 21/12/2014 9:25 PM, Eliad Peller wrote:
> dot11MulticastTransmittedFrameCount should be updated according
> to the DA, which might be different from hdr1.

Shouldn't address 1 be used to determine whether the MPDU is multicast?
>From Std-2012 definition of multicast: "When applied to a MAC protocol
data unit (MPDU), it is an MPDU with a group address in the Address 1
field."

Fred
