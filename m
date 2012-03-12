Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58708 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab2CLJCR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 05:02:17 -0400
Message-ID: <4F5DBB8B.1070000@openwrt.org> (sfid-20120312_100220_953975_C5F76A6C)
Date: Mon, 12 Mar 2012 10:02:03 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k_hw: Fix chip revision checks
References: <1331531853-5043-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1331531853-5043-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-12 6:57 AM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> not sure if these checks are previously avoided may be those revision of
> chipsets are obselete ?
NACK. The extra checks that this patch adds have been intentionally
removed, since all earlier versions were never sold and thus do not need
to be considered. This simplifies the generated binary code.

- Felix
