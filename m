Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:44405 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1HXXxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 19:53:25 -0400
In-Reply-To: <20110824231851.GG5280@broadcom.com>
References: <20110707002034.GA17885@broadcom.com> <20110824222801.GA5280@broadcom.com> <C7234C0A-9839-4150-8B25-F6A6771377A1@iki.fi> <20110824231851.GG5280@broadcom.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <AACF29F3-C672-4DE4-8064-496662A40CB7@iki.fi> (sfid-20110825_015328_239808_783D7F2D)
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Date: Thu, 25 Aug 2011 02:54:22 +0300
To: Henry Ptasinski <henryp@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 25.8.2011, at 2.18, Henry Ptasinski wrote:
> On Wed, Aug 24, 2011 at 04:10:31PM -0700, Aaro Koskinen wrote:
>> On 25.8.2011, at 1.28, Henry Ptasinski wrote:
>>> The drivers compile cleanly for x86 (32- and 64-bit), PPC (32- and
>>> 64-bit),
>>> SPAR, MIPS BE, MIPS LE, and ARM.
>>
>> Are you sure the compilation is even enabled on all of those  
>> platforms?
>>
>> E.g.:
>>
>>> +config BRCMSMAC
>>> +       tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
>>> +       default n
>>> +       depends on PCI
>>> +       depends on WLAN && MAC80211
>>> +       depends on X86 || MIPS
>>            ^^^^^^^^^^^^^^^^^^^^^^
>>
>> Why this?
>
> See my other message.  Wrong link to the patch.  Correct link:
>
> http://linuxwireless.org/en/users/Drivers/brcm80211? 
> action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211- 
> v2.patch

Thanks. The second version builds for ARM, but there's quite a few  
sparse warnings....

A.

