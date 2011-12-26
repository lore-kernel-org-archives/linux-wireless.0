Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43516 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1LZKvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 05:51:11 -0500
Received: by eekc4 with SMTP id c4so10976500eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Dec 2011 02:51:10 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH] mac80211: use RCU read locks for sta_info_get
Date: Mon, 26 Dec 2011 11:51:04 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Paul Stewart <pstew@google.com>
References: <1324882778-3079-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1324882778-3079-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201112261151.05309.chunkeey@googlemail.com> (sfid-20111226_115115_431230_DE501DC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 December 2011 07:59:38 Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> Cc: Paul Stewart <pstew@google.com>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
huh, where did I sign that off? Anyway, You [or John?] can drop that line
and replace it with Cc: stable@kernel.org 

Regards,
	Chr
