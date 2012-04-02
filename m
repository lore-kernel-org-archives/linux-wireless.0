Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36442 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2DBDyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 23:54:49 -0400
Received: by iagz16 with SMTP id z16so3575311iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Apr 2012 20:54:49 -0700 (PDT)
Message-ID: <4F7922FD.60105@lwfinger.net> (sfid-20120402_055452_910993_3BAACAB5)
Date: Sun, 01 Apr 2012 22:54:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	John Linville <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel Panics from ath9k
References: <4F789C57.2090903@lwfinger.net> <20345.4134.204942.124914@gargle.gargle.HOWL>
In-Reply-To: <20345.4134.204942.124914@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/2012 09:34 PM, Sujith Manoharan wrote:

> Should be fixed by this patch: http://marc.info/?l=linux-wireless&m=133282325727326&w=2

Yes, that patch does fix the problem.

BTW, that patch should be pushed to 3.4, and it should have a Cc: Stable, at 
least for 3.3. Make certain that stable gets an E-mail with the commit ID when 
the patch gets into mainline.

I wonder what the problem was with kernels as far back as 3.1. It must have a 
different cause that I still need to explore.

Thanks,

Larry


