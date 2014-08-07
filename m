Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:37982 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757264AbaHGRVf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 13:21:35 -0400
From: Andreas Schlick <ninox@posteo.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Andreas Schlick <ninox@posteo.net>
Subject: [PATCH 0/2] staging: rtl8723au: Small cleanups
Date: Thu,  7 Aug 2014 19:20:48 +0200
Message-Id: <1407432050-5624-1-git-send-email-ninox@posteo.net> (sfid-20140807_192231_577971_3D2F68D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Schlick (2):
  staging: rtl8723au: Move open braces to the previous line.
  staging: rtl8723au: Remove unnecessary bit masking.

 drivers/staging/rtl8723au/core/rtw_efuse.c | 34 ++++++++++--------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

-- 
2.0.4

