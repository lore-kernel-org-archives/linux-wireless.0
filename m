Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:39092 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZHOUAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 16:00:02 -0400
Received: by pzk34 with SMTP id 34so1433945pzk.4
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2009 13:00:03 -0700 (PDT)
Message-ID: <4A8713BE.5020505@lwfinger.net>
Date: Sat, 15 Aug 2009 14:59:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: disable PS by default
References: <200908141323.05936.chunkeey@web.de>
In-Reply-To: <200908141323.05936.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> Johannes kindly pointed out that I completely missed a hunk in
> his patch: "[PATCH] cfg80211: allow driver to override PS default".
> 
> The driver must explicitly set ps_default to false,
> as the setting is pre-filled with the kconfig default.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---

With this patch, I no longer see the disconnects. ACK.

Larry

