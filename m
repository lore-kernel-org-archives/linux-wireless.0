Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab2DEKGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 06:06:06 -0400
Date: Thu, 5 Apr 2012 12:05:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH v2 4/4] rt2800: zero registers of unused TX rings
Message-ID: <20120405100504.GD2378@redhat.com> (sfid-20120405_120609_504343_E74500BE)
References: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
 <1333417250-24560-5-git-send-email-kubakici@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1333417250-24560-5-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 03, 2012 at 03:40:50AM +0200, Jakub Kicinski wrote:
> This is needed if we take over after drivers which use those.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
