Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:59248 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbZLVOSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 09:18:06 -0500
Message-ID: <4B30D519.6010005@gmail.com>
Date: Tue, 22 Dec 2009 15:18:01 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Markus Baier <Markus_Baier@web.de>, Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom
 for alignment operations.
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-5-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-6-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-7-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-8-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-9-git-send-email-gwingerde@gmail.com>	 <loom.20091220T163829-137@post.gmane.org> <4B2E8729.7050501@gmail.com>	 <20091221013316.nm9belnhywwwsc0w-cebfxv@webmail.spamcop.net>	 <4B2FA1CF.1010903@gmail.com> <1261459549.31982.2.camel@ct> <4B307FB1.5040806@gmail.com> <loom.20091222T114501-773@post.gmane.org>
In-Reply-To: <loom.20091222T114501-773@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/22/09 11:55, Markus Baier wrote:
> Gertjan van Wingerde <gwingerde@...> writes:
> 
>> Can you confirm that everything works okay with the original code
>> and this patch applied?
> 
> I restored the original patch from 2.6.33-rc1-wl
> and applied the patch from Pavel Roskin.
> Now it works. Thanks!
> 

OK. Thanks for verifying.

And many thanks for Pavel to come up this quickly with a patch to fix this.

---
Gertjan.
