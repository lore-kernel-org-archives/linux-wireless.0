Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:59558 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbcEWRh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2016 13:37:57 -0400
Reply-To: james@nurealm.net
Subject: Re: "kernel: BUG: scheduling while atomic:" errors with linux kernel
 4.6
References: <e2d89c7d-7567-c3ac-505e-7a9aa887c158@nurealm.net>
 <20160519225612.GB12028@localhost> <573F2FB3.6090206@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Bob Copeland <me@bobcopeland.com>
Cc: hostap@lists.infradead.org, linux-wireless@vger.kernel.org
From: James Feeney <james@nurealm.net>
Message-ID: <e69117a3-50d4-48bc-d67f-c083e6e3af13@nurealm.net> (sfid-20160523_193804_273697_AE1F055F)
Date: Mon, 23 May 2016 11:29:46 -0600
MIME-Version: 1.0
In-Reply-To: <573F2FB3.6090206@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/2016 09:39 AM, Larry Finger wrote:
> @James: Please run the command "dmesg | grep rtl_rfreg_delay". Do any of the
> resulting lines show a value other than "+0x38" for the offset? If that is the
> only one, the attached patch should fix the problem.

Sorry about the delayed response.

$ dmesg | grep rtl_rfreg_delay
[   15.936262]  [<ffffffffa06b1218>] rtl_rfreg_delay+0x38/0x50 [rtlwifi]
[  348.735402]  [<ffffffffa06b1218>] rtl_rfreg_delay+0x38/0x50 [rtlwifi]

So that looks like a no, just the "+0x38" for the offset.

Thanks
James
