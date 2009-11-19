Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:56636 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752373AbZKSVgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 16:36:40 -0500
Message-ID: <4B05BA6A.40305@free.fr>
Date: Thu, 19 Nov 2009 22:36:42 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: lrodriguez@atheros.com, jmalinen@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: This patch fix RX unpadding for any received	frame.
References: <1258665566-4212-1-git-send-email-benoit.papillault@free.fr> <20091119212533.GF4960@tuxdriver.com>
In-Reply-To: <20091119212533.GF4960@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville a écrit :
> On Thu, Nov 19, 2009 at 10:19:26PM +0100, Benoit Papillault wrote:
>> From: Benoit PAPILLAULT <benoit@benoit-laptop.(none)>
>>
>> It has been tested with a 802.11 frame generator and by checking the FCS field
>> of each received frame with the value reported by the Atheros hardware. This
>> patch is useful if you are trying to analyze non standard 802.11 frame going
>> over the air.
>>
>> Signed-off-by: Benoit PAPILLAULT <benoit@benoit-laptop.(none)>
> 
> Are you sure this is this the email address you want?
> 

No. It should be benoit.papillault@free.fr of course. I configured git a
bit too late (after commit).

Sorry about that,
Benoit

