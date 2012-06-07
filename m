Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49381 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab2FGLFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 07:05:05 -0400
Received: by ghrr11 with SMTP id r11so260970ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 04:05:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Jun 2012 17:05:04 +0600
Message-ID: <CADxDmp6=ZMFkqasyt0QV_mALhTZU-V-3M2PY2Mdy573_T0nNLw@mail.gmail.com> (sfid-20120607_130508_757101_A34EE037)
Subject: fix # of MPDUs is in an A-MPDU
From: Kamran Nishat <kamran.nishat@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi ,
Do u know can we limit # of MPDUs is in a A-MPDU. We want to do some
controled experiments. Making A-MPDUs of
constant size will help in great deal.

Kamran
