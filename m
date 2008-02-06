Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:14656 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829AbYBFKxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 05:53:55 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2369902fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 02:53:52 -0800 (PST)
Message-ID: <47A991BE.9030705@gmail.com> (sfid-20080206_105359_537371_0EF885EC)
Date: Wed, 06 Feb 2008 11:53:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
	ath5k-devel@lists.ath5k.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
References: <20080206014131.9d489a34.akpm@linux-foundation.org>	<1202294560-7313-1-git-send-email-jirislaby@gmail.com> <jezluetl7d.fsf@sykes.suse.de>
In-Reply-To: <jezluetl7d.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2008 11:48 AM, Andreas Schwab wrote:
>> +	ah->ah_single_chip = !!(srev >= AR5K_SREV_VER_AR2424 &&
>                            ^^
> 
> This is useless.

Amended locally, thanks.
