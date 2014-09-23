Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:62727 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaIWNzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 09:55:43 -0400
Message-ID: <54217BDC.5060308@broadcom.com> (sfid-20140923_155547_239136_F4597037)
Date: Tue, 23 Sep 2014 15:55:40 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH for-3.12] brcmfmac: handle IF event for P2P_DEVICE interface
References: <1411465946-27161-1-git-send-email-arend@broadcom.com> <20140923132207.GB11359@kroah.com> <542178D2.90804@broadcom.com> <20140923135129.GA12636@kroah.com>
In-Reply-To: <20140923135129.GA12636@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/14 15:51, Greg KH wrote:
> On Tue, Sep 23, 2014 at 03:42:42PM +0200, Arend van Spriel wrote:
>> On 09/23/14 15:22, Greg KH wrote:
>>> On Tue, Sep 23, 2014 at 11:52:26AM +0200, Arend van Spriel wrote:
>>>> upstream: 87c4790330810fe5caf0172d9320cf24ef19cebe
>>>
>>> That commit id doesn't match anything in Linus's tree :(
>>>
>>
>> Hmmm, that is weird:
>>
>> [arend@lb-bun-235 ~/scm/brcm80211-next]
>> $ git remote show torvalds
>> * remote torvalds
>>    Fetch URL:
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>    Push  URL:
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>    HEAD branch: master
>>    Remote branch:
>>      master tracked
>> [arend@lb-bun-235 ~/scm/brcm80211-next]
>> $ git log torvalds/master --oneline -8 -- drivers/net/wireless/brcm80211
>> *87c4790 brcmfmac: handle IF event for P2P_DEVICE interface*
>> 8f2b459 brcmfmac: obtain ifp through wdev structure
>> f1d5603 brcmfmac: conditionally compile firmware protocol source code
>> fac7d2a brcmfmac: Fix memory leak and missing assignment.
>> 2d116b88 brcmfmac: fix memory leakage in msgbuf
>> ebcc2f5 brcmfmac: fix curly brace mistake in brcmf_pcie_handle_mb_data()
>> aef4f5b Merge tag 'master-2014-07-31' of
>> git://git.kernel.org/pub/scm/linux/kern
>> 70b7d94 brcmfmac: Add TDLS support to msgbuf.
>
> Ah, it just went in, sorry for the noise.
>
> But it _just_ went in, why are you emailing this?  We have to wait for a
> -rc release to come out with the patch before being able to add it to
> the tree.

Noted. Did not find that nitty gritty detail in stable_kernel_rules.txt, 
but I just might create a patch for that if I can beat my writers block ;-)

Gr. AvS

> thanks,
>
> greg k-h

