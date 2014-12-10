Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48727 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbaLJTD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 14:03:56 -0500
Message-ID: <5488991A.9000604@candelatech.com> (sfid-20141210_200359_575143_205E5E6A)
Date: Wed, 10 Dec 2014 11:03:54 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: poh <poh@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: unregister and remove frag_threshold callback
References: <1417799786-11391-1-git-send-email-poh@qca.qualcomm.com> <54827F30.8050005@candelatech.com> <548891FB.2060500@qca.qualcomm.com>
In-Reply-To: <548891FB.2060500@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2014 10:33 AM, poh wrote:
> 
> On 12/05/2014 07:59 PM, Ben Greear wrote:
>>
>>
>> On 12/05/2014 09:16 AM, Peter Oh wrote:
>>> Setting fragmentation threshold has not been supported by
>>> any of firmware versions, hence unregister the callback and
>>> remove the function.
>>
>> How hard is it to just fix the firmware instead?
> It's due to hardware limitation such as lack of buffers/RAM size limitation, hence it's very hard from sw perspective.

Out of curiosity, how much more RAM do you need?  I was able to squeeze somewhere around 80k out of the firmware
in my quest to support 64 station vdevs....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

