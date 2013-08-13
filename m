Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39221 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab3HMJo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 05:44:26 -0400
Message-ID: <5209FFED.1040901@openwrt.org> (sfid-20130813_114429_560200_4B763D4C)
Date: Tue, 13 Aug 2013 11:44:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 01/15] ath9k: Add MAX_AMSDU to supported HT capabilities
References: <1376300502-2741-1-git-send-email-sujith@msujith.org> <1376300502-2741-2-git-send-email-sujith@msujith.org>
In-Reply-To: <1376300502-2741-2-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-12 11:41 AM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
I think processing of fragmented rx in ath9k needs to change before we
can enable this. At the moment the driver only supports assembling a
frame from two fragments, which isn't enough to receive large A-MSDU
packets.

- Felix

