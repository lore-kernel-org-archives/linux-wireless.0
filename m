Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from civicrm.laptop.org ([18.85.44.157]:54613 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755141AbdFWU3n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 16:29:43 -0400
Date: Sat, 24 Jun 2017 06:22:56 +1000
From: James Cameron <quozl@laptop.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Jingoo Han <jg1.han@samsung.com>,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Fix lbs_prb_rsp_limit_set()
Message-ID: <20170623202256.GB30867@us.netrek.org> (sfid-20170623_222954_620715_AA053E7D)
References: <20170623151738.qxncismrvd4yzzfr@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170623151738.qxncismrvd4yzzfr@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 23, 2017 at 06:17:38PM +0300, Dan Carpenter wrote:
> The kstrtoul() test was reversed so this always returned -ENOTSUPP.
> 
> Fixes: 27d7f47756f4 ("net: wireless: replace strict_strtoul() with kstrtoul()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: James Cameron <quozl@laptop.org>

-- 
James Cameron
http://quozl.netrek.org/
