Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:36937 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaLUJuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 04:50:44 -0500
Message-ID: <549697F0.8090506@broadcom.com> (sfid-20141221_105049_860645_EE9E3A98)
Date: Sun, 21 Dec 2014 10:50:40 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	<linux-bluetooth@vger.kernel.org>, <linux-nfc@ml01.01.org>,
	"David S. Miller" <davem@davemloft.net>, <lwn@lwn.net>
Subject: Re: changes to Linux wireless maintenance
References: <87388d2tbn.fsf@purkki.adurom.net> <c1f3352bed1f1a2985a5111a077134a5.squirrel@www.codeaurora.org>
In-Reply-To: <c1f3352bed1f1a2985a5111a077134a5.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/14 11:55, Kalle Valo wrote:
> John W. Linville wrote:
>
>> Nevertheless, I think it is time for some changes.  I have been
>> the wireless maintainer for a long time, and I personally would
>> like to develop in a different direction.  Plus, I think that Linux
>> will benefit from having some fresh blood involved in more of the
>> maintenance duties.  I will be stepping aside to let that happen.
>
> Thanks to you both the Linux wireless subsystem as well as the wireless
> community has improved so much from what you started. You will be missed.
> Thank you for all your efforts and I hope you still hang around :)

Congrats with your maintainer role.

>> As for the wireless driver patches, I have asked Kalle Valo
>> to handle patch review and merge duties for everything under the
>> drivers/net/wireless directory.  This will now include not only the ath
>> patches he already manages, but other drivers that don't have trees
>> such as mwifiex, rt2x00, rtlwifi, and others.  For consistency, the
>> iwlwifi tree will also be merged through Kalle's new tree.  I expect
>> that Kalle will announce any relevant details in a follow-up message.
>
> I have created two trees, wireless-drivers and wireless-drivers-next:
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/
>
> The trees work similarly like John's wireless and wireless-next trees, the
> former only for important bugfixes to -rc releases and the latter for the
> rest going to the next release.

So are you dropping the wireless-testing tree? From earlier IRC 
discussion I figured that tree was still in demand.

> I still need to ask both linux-next and kbuild maintainers to add these
> trees to their list of trees to test from, but I hope that to happen in
> the next few days.
>
> There's no need to CC me on the patches, I can pick the patches from the
> mailing list. Actually in the future I'm hoping to use patchwork[1] for
> managing patches, but my access request is still pending in helpdesk's
> queue. I'll send a separate email once I start using patchwork. For the
> time being I just use email to apply patches.

I see. I used to send patches To: the maintainer and Cc: the mailing 
list following SubmittingPatches documentation. I can change my workflow 
so let me know if I should.

Regards,
Arend
