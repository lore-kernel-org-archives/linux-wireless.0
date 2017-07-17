Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:42230 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbdGQUlm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 16:41:42 -0400
Subject: Re: BUG: brcmfmac: add firmware feature detection for gscan feature
 breaks 43430a1
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <25c47ffe-af3e-fb85-ed5b-ff1987cfd93f@mnementh.co.uk>
 <e6635794-7c35-1a46-2d5b-68824c7b0657@mnementh.co.uk>
 <ff344ee3-3feb-6886-8007-d8ed00386424@broadcom.com>
 <c322c7c6-823b-0d36-8968-101d143b3220@mnementh.co.uk>
 <6c512250-5299-0cad-675b-e7780e999b58@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <246dc2f3-5cfd-7e89-6244-50fa2f546306@mnementh.co.uk> (sfid-20170717_224146_327238_5B948214)
Date: Mon, 17 Jul 2017 21:41:26 +0100
MIME-Version: 1.0
In-Reply-To: <6c512250-5299-0cad-675b-e7780e999b58@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/17 21:36, Arend van Spriel wrote:

> In <debugfs_mountpoint>/brcmfmac/*/forensics, but you have to load the
> driver with modules parameter 'ignore_probe_fail=1' to avoid the driver
> remove tearing down all debugfs stuff.

modinfo shows:

parm:           txglomsz:Maximum tx packet chain size [SDIO] (int)
parm:           debug:Level of debug output (int)
parm:           p2pon:Enable legacy p2p management functionality (int)
parm:           feature_disable:Disable features (int)
parm:           alternative_fw_path:Alternative firmware path (string)
parm:           fcmode:Mode of firmware signalled flow control (int)
parm:           roamoff:Do not use internal roaming engine (int)
