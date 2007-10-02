Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:9320 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbXJBIKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 04:10:23 -0400
Received: by ug-out-1314.google.com with SMTP id z38so2052312ugc
        for <linux-wireless@vger.kernel.org>; Tue, 02 Oct 2007 01:10:21 -0700 (PDT)
Message-ID: <4701FCEA.2050200@gmail.com> (sfid-20071002_091028_600830_74F180EA)
Date: Tue, 02 Oct 2007 10:10:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Wireless damage [Was: -mm merge plans for 2.6.24]
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <4701FC79.3060608@gmail.com>
In-Reply-To: <4701FC79.3060608@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Huh, Cc back lkml.

On 10/02/2007 10:08 AM, Jiri Slaby wrote:
> On 10/01/2007 11:22 PM, Andrew Morton wrote:
>> git-net-vs-git-wireless.patch
> 
> Hum, latest wireless-2.6?h=everything already had a proper fix when this patch
> was merged. But pull/push is stuck somewhere :(.
> 
>> git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
>> net-add-ath5k-wireless-driver-fix.patch
> 
> let it live in -mm (wireless-2.6) so far.
> 
>>   Wireless damage control.  Will see what happens.
