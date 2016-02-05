Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35650 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbcBELCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 06:02:41 -0500
Received: by mail-wm0-f49.google.com with SMTP id r129so21427535wmr.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2016 03:02:40 -0800 (PST)
From: Holger Schurig <holgerschurig@gmail.com>
To: qiao <qlnaaa@163.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] how to kick off wifi user
In-Reply-To: <7890ce.11189.15288cfbc26.Coremail.qlnaaa@163.com> (qiao's
	message of "Thu, 28 Jan 2016 23:17:41 +0800 (CST)")
References: <7890ce.11189.15288cfbc26.Coremail.qlnaaa@163.com>
Date: Fri, 05 Feb 2016 12:02:37 +0100
Message-ID: <87h9hnwhbm.fsf@gmail.com> (sfid-20160205_120245_744448_E345C4D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qiao  <qlnaaa@163.com> writes:

> Now I setup AP (ath9k driver) and want to find a way to kick off a
> special wifi user from the AP. I know “iw dev station del”,

You're confusing levels of the ISO 7 level models.

The place where you kick AP users would be in hostapd, not on the driver
level. Or do you think it is feasible to do things differently,
depending if you use ath9k, ath10, iwlwifi, or whatever?  That would be
clumsy. Instead, do it in the piece that actually makes your system an
access point, hostapd.

And therefore this is probably the wrong mailing list to ask such
questions.



Holger

