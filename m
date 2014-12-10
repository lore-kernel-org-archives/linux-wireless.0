Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20720 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbaLJSdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 13:33:44 -0500
Message-ID: <548891FB.2060500@qca.qualcomm.com> (sfid-20141210_193347_386212_77F10958)
Date: Wed, 10 Dec 2014 10:33:31 -0800
From: poh <poh@qca.qualcomm.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>, <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: unregister and remove frag_threshold callback
References: <1417799786-11391-1-git-send-email-poh@qca.qualcomm.com> <54827F30.8050005@candelatech.com>
In-Reply-To: <54827F30.8050005@candelatech.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 12/05/2014 07:59 PM, Ben Greear wrote:
>
>
> On 12/05/2014 09:16 AM, Peter Oh wrote:
>> Setting fragmentation threshold has not been supported by
>> any of firmware versions, hence unregister the callback and
>> remove the function.
>
> How hard is it to just fix the firmware instead?
It's due to hardware limitation such as lack of buffers/RAM size 
limitation, hence it's very hard from sw perspective.
>
> Thanks,
> Ben
>

