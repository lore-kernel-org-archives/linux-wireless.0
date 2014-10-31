Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:41782 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbaJaOhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 10:37:40 -0400
Message-ID: <54539EB0.2050207@broadcom.com> (sfid-20141031_153743_687752_3E192B0D)
Date: Fri, 31 Oct 2014 15:37:36 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>
Subject: Re: brcm80211: use endian annotation for pmk related structure
References: <20141031125136.GA17467@mwanda> <54539A33.6000001@broadcom.com> <20141031142618.GL6890@mwanda>
In-Reply-To: <20141031142618.GL6890@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/14 15:26, Dan Carpenter wrote:
> On Fri, Oct 31, 2014 at 03:18:27PM +0100, Arend van Spriel wrote:
>> Understood. Not sure what the motivation is to mistrust endian more.
>
> Endian data tends to come from suspicious places such as disk images,
> usb devices, and networks.
>
>> Simply because there could be conversion errors? Anyway, the main
>> question is whether pmkid_len is always between 0 and
>> WLAN_PMKID_LEN. As far as I know it is. We could 1) add additional
>> checks here, 2) make pmkid_len of u32 type, or 3) just mention the
>> (sure) assumption in a comment. I would prefer option 2) or 3).
>
> I would prefer 2.  Static checker warnings are a pain.

Now who has been tinkering on static checkers ;-) Anyway, option 2) it 
is. Who will do the patch? :-p

Regards,
Arend
