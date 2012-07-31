Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab2GaNc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 09:32:29 -0400
Date: Tue, 31 Jul 2012 15:32:14 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: users@rt2x00.serialmonkey.com, kevin.chou@mediatek.com,
	woody.hung@mediatek.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH v3] rt2x00 : fix rt3290 resuming failed.
Message-ID: <20120731133213.GB3606@redhat.com> (sfid-20120731_153248_889640_C092B582)
References: <1343739105-19091-1-git-send-email-machen@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343739105-19091-1-git-send-email-machen@suse.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 31, 2012 at 08:51:45PM +0800, Chen, Chien-Chia wrote:
>  	u32 reg;
>  
> +	int retval;
Keep declarations together.

Stanislaw
