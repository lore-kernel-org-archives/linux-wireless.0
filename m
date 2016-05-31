Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42866 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbcEaLKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 07:10:11 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>,
	Sven Eckelmann <sven.eckelmann@open-mesh.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v1] ath10k: Fix 10.4 extended peer stats update
Date: Tue, 31 May 2016 11:09:38 +0000
Message-ID: <87fusyeb6d.fsf@qca.qualcomm.com> (sfid-20160531_131015_018337_39352554)
References: <1462947870-17196-1-git-send-email-mohammed@qca.qualcomm.com>
	<6103547.auMgQrn60O@bentobox>	<20160527090649.GA14846@atheros-ThinkPad-T61>
	<1464676666571.16234@qti.qualcomm.com>
In-Reply-To: <1464676666571.16234@qti.qualcomm.com> (Mohammed Shafi
	Shajakhan's message of "Tue, 31 May 2016 06:36:48 +0000")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Shajakhan, Mohammed Shafi (Mohammed Shafi)" <mohammed@qti.qualcomm.com>
writes:
> seems the change got merged in pending branch
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=master-pending&id=2a872321e07506e339fc1b3ca81aa3e88628cd6e
>
> Request if you can send the patch to address this(incase the patch cannot be dropped)
> and the v2 version cannot be picked

The pending branches (pending and pending-master) are just for build and
runtime testing, they can be freely modified or dropped. v2 is now in
pending branch and I'm looking at the patch right now.

-- 
Kalle Valo