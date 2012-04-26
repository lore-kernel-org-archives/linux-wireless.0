Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64847 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2DZLfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 07:35:06 -0400
Message-ID: <4F9932E6.1040403@qca.qualcomm.com> (sfid-20120426_133539_255945_981BF8C2)
Date: Thu, 26 Apr 2012 14:35:02 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath6kl: properly use pr_fmt()
References: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org> <1335234998-31547-2-git-send-email-mcgrof@frijolero.org>
In-Reply-To: <1335234998-31547-2-git-send-email-mcgrof@frijolero.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2012 05:36 AM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> pr_fmt() is either defined or we redefine it. Typically
> drivers define it prior to including printk.h but this
> is done under the assumption that no other subsystem
> it uses has already defined pr_fmt(). In such cases
> pr_fmt() should be undefined and redefined.
> 
> Doing this properly shaves down compilation time quite
> considerably.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>

I'm dropping this based on the feedback from davem.

Kalle
