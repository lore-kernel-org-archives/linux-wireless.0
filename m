Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52629 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1BDSfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 13:35:03 -0500
Received: by fxm20 with SMTP id 20so2714829fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 10:35:02 -0800 (PST)
Message-ID: <4D4C4705.4060001@lwfinger.net>
Date: Fri, 04 Feb 2011 12:35:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Drop patch "[PATCH] rtlwifi: Fix sparse messages"
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please drop the patch mentioned in the title.

To minimize the code duplication when adding the rtl8192cu driver to the rtlwifi
tree, I need to do a major rewrite. I will pick up those sparse warnings when I
do that.

Thanks,

Larry
