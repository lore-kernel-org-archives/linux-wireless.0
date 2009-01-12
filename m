Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42619 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260AbZALUKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:10:14 -0500
Message-ID: <496BA39F.6040600@lwfinger.net> (sfid-20090112_211019_368483_C01D87C6)
Date: Mon, 12 Jan 2009 14:10:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: fix =?UTF-8?B?IuKAmGdtb2Rl4oCZIG1heSBiZSB1c2VkIA==?=
 =?UTF-8?B?dW5pbml0aWFsaXplZCIgd2FybmluZw==?=
References: <> <1231789741-13433-1-git-send-email-linville@tuxdriver.com> <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_config=E2=
=80=99:
> drivers/net/wireless/b43/main.c:3264: warning: =E2=80=98gmode=E2=80=99=
 may be used uninitialized

What version of gcc generates this warning? Mine (gcc (SUSE Linux)
4.3.2) does not.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
