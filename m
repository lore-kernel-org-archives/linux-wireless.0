Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12902 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2DWLhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 07:37:14 -0400
Message-ID: <4F953EE7.9000006@qca.qualcomm.com> (sfid-20120423_133720_748762_B06D3DBF)
Date: Mon, 23 Apr 2012 14:37:11 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch 1/2] ath6kl: change || to &&
References: <20120420064328.GC22649@elgon.mountain>
In-Reply-To: <20120420064328.GC22649@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2012 09:43 AM, Dan Carpenter wrote:
> The original conditions are always true.  I think && was intended here,
> but I don't have the hardware to test.  Could you take a look?
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, both patches applied to ath6kl.git.

Kalle
