Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2403 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522Ab0ESSdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 14:33:22 -0400
Message-ID: <4BF42EEF.6020900@gmail.com>
Date: Wed, 19 May 2010 20:33:19 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 5/7] rt2x00: Move PCI/USB specific register initializations
 to rt2800{pci,usb}.
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com> <1274282769-19244-6-git-send-email-gwingerde@gmail.com> <201005192026.53773.IvDoorn@gmail.com>
In-Reply-To: <201005192026.53773.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/10 20:26, Ivo van Doorn wrote:
> On Wednesday 19 May 2010 17:26:07 Gertjan van Wingerde wrote:
>> This prevents us having common code depend on PCI or USB specific code.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
> 
> To which tree are you creating your diffs?
> This one doesn't apply to latest wireless-testing.git or rt2x00,git
> 

All my patches are against wireless-next-2.6.git, as that is the tree John will use to merge patches
in.

I believe there indeed is a slight difference between that tree and wireless-testing.git
with respect to the <linux/slab.h> inclusion, causing applying errors against wireless-testing.

---
Gertjan.

