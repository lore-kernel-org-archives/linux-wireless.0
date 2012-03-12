Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34076 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab2CLUQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 16:16:57 -0400
Date: Mon, 12 Mar 2012 13:16:50 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k_hw: Fix chip revision checks
Message-ID: <20120312201650.GG26059@tux> (sfid-20120312_211700_807775_031B96F1)
References: <1331531853-5043-1-git-send-email-mohammed@qca.qualcomm.com>
 <4F5DBB8B.1070000@openwrt.org>
 <4F5DBED4.4050500@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F5DBED4.4050500@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2012 at 02:46:04PM +0530, Mohammed Shafi Shajakhan wrote:
> Hi Felix,
> 
> On Monday 12 March 2012 02:32 PM, Felix Fietkau wrote:
> >On 2012-03-12 6:57 AM, Mohammed Shafi Shajakhan wrote:
> >>From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> >>
> >>not sure if these checks are previously avoided may be those revision of
> >>chipsets are obselete ?
> >NACK. The extra checks that this patch adds have been intentionally
> >removed, since all earlier versions were never sold and thus do not need
> >to be considered. This simplifies the generated binary code.
> 
> IMHO i don't think this patch does anything wrong to deserve a NACK!
> sometimes these optimizations make it tad difficult if we want to
> quickly check with the HAL code.

"HAL" code from internal codebases need to change, not the other
way around. You have your priorities wrong. I support the NACK.

  Luis
