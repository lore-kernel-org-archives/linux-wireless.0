Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50789 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbXGKQWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 12:22:45 -0400
Message-ID: <469503CC.8050500@lwfinger.net>
Date: Wed, 11 Jul 2007 11:22:36 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: stable@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [stable] [PATCH] softmac: Fix ESSID problem
References: <4692e2e0.u/1KuH/5hSPtXvF9%Larry.Finger@lwfinger.net> <20070711071418.GS4306@sequoia.sous-sol.org>
In-Reply-To: <20070711071418.GS4306@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chris Wright wrote:
> * Larry Finger (Larry.Finger@lwfinger.net) wrote:
>> From: Jean Tourrilhes <jt@hpl.hp.com>
>>
>> Victor Porton reported that the SoftMAC layer had random problem when setting the ESSID :
>> http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it turned out to be
>> worse, the SoftMAC layer is left in an inconsistent state. The fix is pretty trivial.
>>
>> Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
>> Acked-by: Michael Buesch <mb@bu3sch.df>
>> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Please resend when this is accepted upstream.

As you heard from John Linville, the patch has been sent upstream, but I'll resend it when it hits 
Linus's tree.

Larry
