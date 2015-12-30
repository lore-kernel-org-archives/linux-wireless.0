Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38702 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbL3O7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 09:59:20 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/14] mwifiex: change ap and station interface limits
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1450095315-19927-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20151230145919.D060D60343@smtp.codeaurora.org> (sfid-20151230_155924_015588_CC9C3D3B)
Date: Wed, 30 Dec 2015 14:59:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Shengzhen Li <szli@marvell.com>
> 
> ap/station interface limit has been changed to allow
> creating maximum 3 interfaces.
> 
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 14 patches applied to wireless-drivers-next.git:

eb5d912e1564 mwifiex: change ap and station interface limits
5b13d3e1f926 mwifiex: multiple bss support
5eab67779974 mwifiex: advertise SMS4 cipher suite
c8ac6a8ee8e7 mwifiex: fix bug for wildcard-prefix wowlan pattern
b0922ffa706b mwifiex: increase supported wowlan pattern length
abffd274a243 mwifiex: abort cac in del_station() handler
bd642acf3213 mwifiex: suppress "Rx of mgmt packet failed" message
47f336d7e0df mwifiex: remove redundant timestamp assignment
76ae3e26ea43 mwifiex: add debugfs file for testing reset of card
776f742040ca mwifiex: fix AMPDU not setup on TDLS link problem
7f3f1245ffcd mwifiex: fix wake on disconnect feature
610d0af8e8d2 mwifiex: update region_code_index array
19b0a71017aa mwifiex: use world for unidentified region code
84a38fb3167e mwifiex: fix WPA connection problem

Kalle Valo
