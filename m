Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58837 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965335Ab2CAJvi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 04:51:38 -0500
MIME-Version: 1.0
In-Reply-To: <20120301070208.GH1003@mwanda>
References: <20120229063555.GC18031@elgon.mountain>
	<4F4DE009.7010808@bfs.de>
	<20120301070208.GH1003@mwanda>
Date: Thu, 1 Mar 2012 10:51:37 +0100
Message-ID: <CAOmT4fS1jnywLoiMJjewFi2-w1UHySNPCEhAbrZwW01OS1hV6w@mail.gmail.com> (sfid-20120301_105152_859600_D4AC5EF5)
Subject: Re: [patch 1/4 v2] rndis_wlan: integer overflows in rndis_wlan_do_link_up_work()
From: bojan prtvar <prtvar.b@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: walter harms <wharms@bfs.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On Thu, Mar 1, 2012 at 8:02 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
>
>
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Fixed a style issue for Walter Harms.  Changed > 0 to != 0.
>

Why not just  if (req_ie_len) and if (resp_ie_len) ?

Regards,
Bojan
