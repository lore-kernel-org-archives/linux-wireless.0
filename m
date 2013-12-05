Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51773 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3LEKWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 05:22:32 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21152.21195.479607.597294@gargle.gargle.HOWL> (sfid-20131205_112236_187730_58F46DEB)
Date: Thu, 5 Dec 2013 15:47:47 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [RFC 08/12] ath9k: Use a separate TX gain table for WZR-HP-G450H
In-Reply-To: <52A05325.2070501@openwrt.org>
References: <1386233177-11132-1-git-send-email-sujith@msujith.org>
	<1386233177-11132-9-git-send-email-sujith@msujith.org>
	<52A05325.2070501@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> The ath9k_platform_data structure in 'include/linux/ath9k_platform.h' should be
> updated as well. Otherwise this will cause a build error.

Thanks. I'll squash patches 07 and 08 into a single one.

Sujith
