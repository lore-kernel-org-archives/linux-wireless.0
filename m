Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12759 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1HKPvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 11:51:05 -0400
Message-ID: <4E43FA61.1010301@qca.qualcomm.com> (sfid-20110811_175124_781897_AF0F617E)
Date: Thu, 11 Aug 2011 18:50:57 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 & staging trees related)
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au> <4E438D56.5020801@qca.qualcomm.com> <20110811141604.GA14763@suse.de>
In-Reply-To: <20110811141604.GA14763@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2011 05:16 PM, Greg KH wrote:
> On Thu, Aug 11, 2011 at 11:05:42AM +0300, Kalle Valo wrote:
>
>> Yes, the cleaned up version of ath6kl is now in wireless-next and the
>> staging version can be removed in 3.2. Greg, how do you want to handle
>> removal of the staging version? Should I send a patch to you removing
>> it? Or should I send the patch to John?
> 
> Just tell me.  Should I really delete drivers/staging/ath6kl/ for the
> 3.2 kernel release?  If so, I'll gladly do so in my tree so linux-next
> will be fine for issues like this in the future.

Yes, please delete ath6kl from staging for the 3.2 release as the
cleanup version is now in wireless-next.

Thank you everyone and sorry for the mess.

Kalle
