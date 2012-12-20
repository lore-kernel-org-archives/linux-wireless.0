Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51971 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2LTNkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 08:40:03 -0500
Message-ID: <1356010819.10029.15.camel@jlt4.sipsolutions.net> (sfid-20121220_144007_637047_E3B86449)
Subject: Re: [PATCH 2/3] iwl3945: disable 11a support
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 20 Dec 2012 14:40:19 +0100
In-Reply-To: <1356010313-9782-2-git-send-email-sgruszka@redhat.com> (sfid-20121220_143208_346303_FEE45543)
References: <1356010313-9782-1-git-send-email-sgruszka@redhat.com>
	 <1356010313-9782-2-git-send-email-sgruszka@redhat.com>
	 (sfid-20121220_143208_346303_FEE45543)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 14:31 +0100, Stanislaw Gruszka wrote:
> I don't believe if there still are users using 11a mode. If they are,
> they should probably update their network to something that was
> designed in current century, but I also left module option for them.

Huh? All of VHT etc. is going to use 5 GHz and will be compatible with
legacy clients, so having 11a support will allow them to connect to new
networks? Or am I midunderstanding what you're doing here?

johannes

