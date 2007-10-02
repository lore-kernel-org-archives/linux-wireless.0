Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:7052 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXJBIIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 04:08:30 -0400
Received: by ug-out-1314.google.com with SMTP id z38so2052094ugc
        for <linux-wireless@vger.kernel.org>; Tue, 02 Oct 2007 01:08:29 -0700 (PDT)
Message-ID: <4701FC79.3060608@gmail.com> (sfid-20071002_090840_296795_9162D09B)
Date: Tue, 02 Oct 2007 10:08:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>
Subject: Wireless damage [Was: -mm merge plans for 2.6.24]
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2007 11:22 PM, Andrew Morton wrote:
> git-net-vs-git-wireless.patch

Hum, latest wireless-2.6?h=everything already had a proper fix when this patch
was merged. But pull/push is stuck somewhere :(.

> git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
> net-add-ath5k-wireless-driver-fix.patch

let it live in -mm (wireless-2.6) so far.

>   Wireless damage control.  Will see what happens.

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
