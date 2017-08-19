Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:40040 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751267AbdHSUdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 16:33:14 -0400
Subject: Re: [PATCH 31/34] brcmfmac: Remove func0 from function array
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-32-ian@mnementh.co.uk>
 <21ea2a49-c797-b427-1ee7-ff8164c8f95c@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <73b9b330-b2cb-f348-e17d-0c489c222676@mnementh.co.uk> (sfid-20170819_223317_194000_4D64174C)
Date: Sat, 19 Aug 2017 21:33:12 +0100
MIME-Version: 1.0
In-Reply-To: <21ea2a49-c797-b427-1ee7-ff8164c8f95c@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/17 12:19, Arend van Spriel wrote:
>> -	sdio_f0_readb((sdiodev)->func[0], (addr), (r))
>> +	sdio_f0_readb((sdiodev)->func[1], (addr), (r))
> 
> There is no reason to keep these any longer as these do not provide any
> functionality over the core sdio function unless you consider the
> sdiodev dereference.

I'm happy to submit an incremental patch to these that gets us right
down to the linux mmc core functions. Just seemed like too big a change
to do in one hit.

-Ian
