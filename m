Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47931 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2BBL2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 06:28:25 -0500
Received: by vbjk17 with SMTP id k17so1685755vbj.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 03:28:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120202042521.GA20635@ubuntu-macmini>
References: <20120202042521.GA20635@ubuntu-macmini>
Date: Thu, 2 Feb 2012 16:58:23 +0530
Message-ID: <CAD2nsn0tk_A18vjsCzgO2_7swuM=VPghyTaiHjkHAUc3h3+MiQ@mail.gmail.com> (sfid-20120202_122828_705406_89552916)
Subject: Re: CTS timeout issue with AR9285
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 2, 2012 at 9:55 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> I recently updated a machine with AR9285 wireless from kernel version
> 3.0 to 3.2 and saw that wireless had become slow and unreliable. It
> seems that the problem is extremely frequent CTS timeouts, which began
> happening with commit adb5066 (ath9k_hw: do not apply the 2.4 ghz ack
> timeout workaround to cts). Restoring the CTS timeout to the value prior
> to this commit on top of 3.2 gets performance back to what it was with
> 3.0.

does the environment is a noisy one (or) clear one

>
> I don't have any other ath9k cards lying around, but various other cards
> are working fine with this router. Any ideas what's wrong here?
>
> Thanks,
> Seth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
shafi
