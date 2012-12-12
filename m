Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56501 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2LLPw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 10:52:57 -0500
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joe Perches <joe@perches.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 12 Dec 2012 07:56:10 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH v10 2/3] wil6210: Local compensation for dynamic hexdump
Message-ID: <20121212155610.GK15974@pogo> (sfid-20121212_165303_471927_BF24C211)
References: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1355327278-12965-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1355327278-12965-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2012 at 05:47:57PM +0200, Vladimir Kondratiev wrote:
> Unless patch for dynamic hexdump merged into mainstream kernel,
> need to provide replacement for the dynamic hexdump functionality
> 
> This patch do not hurt compilation with kernel that have
> 'dynamic hexdump' patch merged - check performed by
> #if !defined(print_hex_dump_debug)
> 
> To REMOVE when dynamic hexdump merged!!
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

I'd say just prefix with wil_ for now.

  Luis
