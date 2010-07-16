Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50152 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935038Ab0GPAq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 20:46:59 -0400
Date: Thu, 15 Jul 2010 20:46:58 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	kyle@parisc-linux.org
Subject: Re: [RFC] wireless: only use alpha2 regulatory information from
 country IE
Message-ID: <20100716004658.GG10884@bombadil.infradead.org>
References: <1279220807-18245-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279220807-18245-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 15, 2010 at 03:06:47PM -0400, John W. Linville wrote:
> The meaning and/or usage of the country IE is somewhat poorly defined.
> In practice, this means that regulatory rulesets in a country IE are
> often incomplete and might be untrustworthy.  This removes the code
> associated with interpreting those rulesets while preserving respect
> for country "alpha2" codes also contained in the country IE.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> This patch is compile-tested only!  Please feel free to suggest that
> I have left something out or missed some nuance of our regulatory
> enforcement code...
> 

Building it now...
