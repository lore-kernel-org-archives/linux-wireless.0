Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63460 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2CTKGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 06:06:14 -0400
Message-ID: <4F685690.5020102@qca.qualcomm.com> (sfid-20120320_110635_677385_10A6D275)
Date: Tue, 20 Mar 2012 12:06:08 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-next 3/3] ath6kl: Add __printf verification to
 ath6kl_printk
References: <cover.1332116921.git.joe@perches.com> <a27a7b0fcddc2f2366ff5ab0968ca0ff78d420c5.1332116921.git.joe@perches.com>
In-Reply-To: <a27a7b0fcddc2f2366ff5ab0968ca0ff78d420c5.1332116921.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2012 02:30 AM, Joe Perches wrote:
> Make sure printf formats and arguments match.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, I have applied this to ath6kl.git. John, I hope this is ok for you.

Kalle
