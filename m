Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37056 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753491AbYJTMrm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 08:47:42 -0400
Message-ID: <48FC7DEC.9060200@gmx.de> (sfid-20081020_144803_251705_97A98430)
Date: Mon, 20 Oct 2008 14:47:40 +0200
From: Dieter Ries <clip2@gmx.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: iwl3945 broken in current git
References: <48FC6C05.6020901@gmx.de>	 <20081020121710.GA3607@isilmar.linta.de>	 (sfid-20081020_141718_690091_E56EF8AB) <1224506010.27899.23.camel@johannes.berg>	 <48FC7B1A.10307@gmx.de> (sfid-20081020_143609_718157_68144039) <1224506366.27899.25.camel@johannes.berg>
In-Reply-To: <1224506366.27899.25.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:
> On Mon, 2008-10-20 at 14:35 +0200, Dieter Ries wrote:
>> Johannes Berg schrieb:
>>> On Mon, 2008-10-20 at 14:17 +0200, Dominik Brodowski wrote:
>>>
>>>>> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
>>>>> iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
>>>>> 0x4416 ser 0x0000004B
>>>>> iwl3945: Can't stop Rx DMA.
>>>> It needs a more recent uCode -- the driver really should scream out loudly
>>>> that the old firmware no longer suffices.
>>> You could try reverting ef224ca2ce55e81acc6c3a74c3e8c00a00941c70, that's
>>> the only commit I can find that seems to be vaguely related to the
>>> problem as Tomas described it. Not that it might not be hidden in some
>>> other commit...
>> The new firmware did it. It works now, but it should really scream out
>> loud ...
> 
> Do you still have the old one? Would you try anyway?

ahem, I don't seem to have ef224ca2ce55e81acc6c3a74c3e8c00a00941c70, are
you sure that is the right hash?

> 
> johannes

cu
Dieter
