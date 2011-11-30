Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3346 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab1K3ULy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 15:11:54 -0500
Message-ID: <4ED68E03.4010804@broadcom.com> (sfid-20111130_211156_762288_CBB2C51D)
Date: Wed, 30 Nov 2011 12:11:47 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] brcm80211: avoid code duplication on set tx
 power
References: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1322516330-4007-5-git-send-email-mcgrof@qca.qualcomm.com>
In-Reply-To: <1322516330-4007-5-git-send-email-mcgrof@qca.qualcomm.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2011 01:38 PM, Luis R. Rodriguez wrote:
> Both cases are doing the same so treat the switch cases
> for both as an "or".
>
> Signed-off-by: Luis R. Rodriguez<mcgrof@qca.qualcomm.com>

Thanks Luis,

Acked-by: Franky Lin <frankyl@broadcom.com>

Franky


