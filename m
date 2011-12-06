Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46860 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1LFVAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 16:00:12 -0500
Date: Tue, 6 Dec 2011 15:59:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 4/4] ath9k: enable ANI for ar9100 chips
Message-ID: <20111206205934.GF30288@tuxdriver.com> (sfid-20111206_220022_706545_1105FF02)
References: <1322883557-14120-1-git-send-email-mar.kolya@gmail.com>
 <1322883557-14120-5-git-send-email-mar.kolya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1322883557-14120-5-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 02, 2011 at 10:39:17PM -0500, Nikolay Martynov wrote:
>   Enable ANI for ar9100 since it seems to be working fine (and as a matter of fact ANI was always performed for ar9100 since code which was supposed to disable it didn't achieve this goal).
>   This patch sets config.enable_ani to default (true) value for ar9100.
> 
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>

Please wrap the lines in your changelog.  Somewhere around 72
characters looks nice.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
