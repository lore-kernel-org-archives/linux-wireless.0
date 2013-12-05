Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:58514 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3LEKdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 05:33:35 -0500
Message-ID: <52A0569A.3080800@openwrt.org> (sfid-20131205_113338_281361_CA73728A)
Date: Thu, 05 Dec 2013 11:34:02 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [RFC 08/12] ath9k: Use a separate TX gain table for WZR-HP-G450H
References: <1386233177-11132-1-git-send-email-sujith@msujith.org>	<1386233177-11132-9-git-send-email-sujith@msujith.org>	<52A05325.2070501@openwrt.org> <21152.21195.479607.597294@gargle.gargle.HOWL>
In-Reply-To: <21152.21195.479607.597294@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.12.05. 11:17 keltezéssel, Sujith Manoharan írta:
> Gabor Juhos wrote:
>> The ath9k_platform_data structure in 'include/linux/ath9k_platform.h' should be
>> updated as well. Otherwise this will cause a build error.
> 
> Thanks. I'll squash patches 07 and 08 into a single one.

Sorry, I did not notice that you have added that in 07. Doing that within one
patch would be better indeed.

-Gabor
