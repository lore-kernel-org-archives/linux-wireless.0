Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765476AbXJQCvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 22:51:38 -0400
Subject: Re: [PATCH] jiffies_round -> jiffies_round_relative conversion -
	ipw2100/ipw2200
From: Zhu Yi <yi.zhu@intel.com>
To: Anton Blanchard <anton@samba.org>,
	"John W.Linville" <linville@tuxdriver.com>
Cc: jketreno@linux.intel.com, arjan@linux.intel.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071015053801.GB3257@kryten>
References: <20071015053428.GA3257@kryten>  <20071015053801.GB3257@kryten>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 10:40:06 +0800
Message-Id: <1192588806.2992.7.camel@debian.sh.intel.com> (sfid-20071017_035144_838484_5F010B7A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-10-15 at 00:38 -0500, Anton Blanchard wrote:
> 
> When rounding a relative timeout we need to use
> round_jiffies_relative(). 

ACK.

John, please apply this patch to wireless-2.6. Thanks.

-yi
