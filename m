Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23449 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2DPG1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:27:44 -0400
Message-ID: <4F8BBBDA.9030502@qca.qualcomm.com> (sfid-20120416_082749_816561_2857DB86)
Date: Mon, 16 Apr 2012 09:27:38 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [patch] ath6kl: list_first_entry() is never NULL
References: <20120413192718.GD18505@elgon.mountain>
In-Reply-To: <20120413192718.GD18505@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/13/2012 10:27 PM, Dan Carpenter wrote:
> We can remove the NULL check here.  It triggers a Smatch warning because
> list_first_entry() never is NULL and people who check for it normally
> intend to check for list_empty() instead.  In these cases however,
> we've already verified that the lists are not empty.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to ath6kl.git.

Kalle
