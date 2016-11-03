Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:53216 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751474AbcKCC6t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 22:58:49 -0400
Date: Wed, 02 Nov 2016 22:58:42 -0400 (EDT)
Message-Id: <20161102.225842.248777008402902889.davem@davemloft.net> (sfid-20161103_035921_886354_56FD81D8)
To: Larry.Finger@lwfinger.net
Cc: john@zgus.com, Jes.Sorensen@redhat.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix for bogus data used to determine
 macpower
From: David Miller <davem@davemloft.net>
In-Reply-To: <10e32bb4-fe16-6a0f-eaf4-1142c23e7b56@lwfinger.net>
References: <cover.1477769750.git.john@zgus.com>
        <20161030102112.GA5789@cube>
        <10e32bb4-fe16-6a0f-eaf4-1142c23e7b56@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 2 Nov 2016 20:00:03 -0500

> On 10/30/2016 05:21 AM, John Heenan wrote:
>> Code tests show data returned by rtl8xxxu_read8(priv, REG_CR), used to
>> set
>> macpower, is never 0xea. It is only ever 0x01 (first time after
>> modprobe)
>> using wpa_supplicant and 0x00 thereafter using wpa_supplicant. These
>> results
>> occurs with 'Fix for authentication failure' [PATCH 1/2] in place.
>>
>> Whatever was returned, code tests always showed that at least
>> rtl8xxxu_init_queue_reserved_page(priv);
>> is always required. Not called if macpower set to true.
>>
>> Please see cover letter, [PATCH 0/2], for more information from tests.
> 
> That cover letter will NOT be included in the commit message, thus
> referring to it here is totally pointless.

This is why when a patch series is added to GIT, the cover letter
must be added to the merge commit that adds that series.

It is therefore perfectly valid to refer to such text from a
commit contained by that merge commit.
