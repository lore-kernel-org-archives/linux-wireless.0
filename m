Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53253 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1HLON2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 10:13:28 -0400
Message-ID: <4E453502.4000401@qca.qualcomm.com> (sfid-20110812_161345_074887_89870B50)
Date: Fri, 12 Aug 2011 17:13:22 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <gregkh@suse.de>,
	<linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 & staging trees related)
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au> <4E438D56.5020801@qca.qualcomm.com> <20110811141604.GA14763@suse.de> <4E43FA61.1010301@qca.qualcomm.com> <20110812121216.28e6979b44bacb651849640b@canb.auug.org.au> <20110812135101.GA2286@tuxdriver.com>
In-Reply-To: <20110812135101.GA2286@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 04:51 PM, John W. Linville wrote:
> On Fri, Aug 12, 2011 at 12:12:16PM +1000, Stephen Rothwell wrote:
>> On Thu, 11 Aug 2011 18:50:57 +0300 Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>>
>>> Yes, please delete ath6kl from staging for the 3.2 release as the
>>> cleanup version is now in wireless-next.
>>>
>>> Thank you everyone and sorry for the mess.
>>
>> I think that the removal should be done in the wirelesss tree so that
>> Linus' tree is not broken during the next merge window.
>>
>> I have added the removal patch as a merge fixup one the merge of the
>> wireless tree for today.
> 
> Makes sense to me -- probably also is more sane if there is some fool
> out there relying on the ath6kl driver in staging that doesn't know
> about the switch to the wireless tree.

Ok, I'll send a patch to John which removes the staging driver.

Kalle
