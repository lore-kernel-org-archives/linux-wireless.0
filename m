Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:50946 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbAWGNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 01:13:43 -0500
Date: Fri, 23 Jan 2015 17:13:28 +1100
From: James Cameron <quozl@laptop.org>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, yogeshp@marvell.com, nishants@marvell.com,
	frankh@marvell.com
Subject: Re: [PATCH v2 1/3] mwifiex: add support for SD8801
Message-ID: <20150123061328.GB25167@us.netrek.org> (sfid-20150123_071346_367990_C9C60B7B)
References: <1422013159-3093-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422013159-3093-1-git-send-email-patila@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2015 at 05:09:17PM +0530, Avinash Patil wrote:
> From: Yogesh Ashok Powar <yogeshp@marvell.com>
> 
> SD8801 is Marvell's 1x1 802.11bgn offering.
> This patch adds Device IDs for SD8801 and also defines card
> structure which has definition for register offsets, buffer sizes etc.
> 
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Frank Huang <frankh@marvell.com>

Reviewed-by: James Cameron <quozl@laptop.org>

(Not tested, still on 8787 with 3.5).

-- 
James Cameron
http://quozl.linux.org.au/
