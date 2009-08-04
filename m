Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33023 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932383AbZHDXqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 19:46:14 -0400
Message-ID: <4A78C842.9060303@gmx.de>
Date: Wed, 05 Aug 2009 01:46:10 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath5k: fix missing output in monitor mode after	ifconfig
 up
References: <4A74C2B6.3070407@gmx.de> <20090802032019.GA25339@hash.localnet> <4A754562.8000107@gmx.de> <20090804154153.GB4995@tuxdriver.com>
In-Reply-To: <20090804154153.GB4995@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/04/2009 05:41 PM, John W. Linville wrote:
> On Sun, Aug 02, 2009 at 09:50:58AM +0200, Joerg Albert wrote:
>> Let ath5k_chan_set() always call ath5k_reset().
>> This fixes the bug that we don't
>> get any packets in monitor mode after:
>>
>> ifconfig wlan0 down
>> iwconfig wlan0 mode monitor channel 1
>> ifconfig wlan0 up
>>
>> but they arrive after
>>
>> iwconfig wlan0 channel 2
>>
>> Signed-off-by: Joerg Albert <jal2@gmx.de>
> 
> patching file drivers/net/wireless/ath/ath5k/base.c
> Hunk #1 FAILED at 1071.
> Hunk #2 FAILED at 1083.
> Hunk #3 FAILED at 2804.
> 3 out of 3 hunks FAILED -- saving rejects to file drivers/net/wireless/ath/ath5k/base.c.rej

Sorry, seems like Thunderbird has converted the whitespaces.
I'll repost the patch.

