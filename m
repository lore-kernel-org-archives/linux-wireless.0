Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35588 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbcFAPnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 11:43:07 -0400
Message-ID: <574EC331.1080901@gmail.com> (sfid-20160601_174334_276584_0F6097C7)
Date: Wed, 01 Jun 2016 16:42:49 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	ath9k-devel <ath9k-devel@qualcomm.com>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Miaoqing Pan <miaoqing@codeaurora.org>
Subject: Re: ath9k gpio request
References: <20160530132225.4d297678@canb.auug.org.au>	<574C4851.9090201@gmail.com> <87fusy3cqx.fsf_-_@kamboji.qca.qualcomm.com>,<574D3EAA.3060102@gmail.com> <1464764036580.70506@qti.qualcomm.com>
In-Reply-To: <1464764036580.70506@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 June 2016 12:24 PM, Pan, Miaoqing wrote:
> which chip ?  And what's the GPIO number ?

lspci -v reports:
09:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network 
Adapter (rev 01)
	Subsystem: Foxconn International, Inc. Device e052
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at c0500000 (64-bit, non-prefetchable) [size=512K]
	Expansion ROM at c0580000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 2
	Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
	Capabilities: [70] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: ath9k

Any easy way to find out the gpio number or i can modify the module to 
find that out.

Regards
Sudip
