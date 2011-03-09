Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47985 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab1CIDeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 22:34:17 -0500
Message-ID: <4D76F536.6000403@openwrt.org>
Date: Wed, 09 Mar 2011 04:34:14 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: update minstrel_ht sample rate when probe is
 set
References: <AANLkTi=wuAcm-25WHsRopc08UHEt9p0-5V=0GkpeqRK8@mail.gmail.com>
In-Reply-To: <AANLkTi=wuAcm-25WHsRopc08UHEt9p0-5V=0GkpeqRK8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-09 2:41 AM, Daniel Halperin wrote:
> Waiting until the status is received can cause the same rate to be
> probed multiple times consecutively.
> 
> Cc: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Mangled by line wrapping, please resend. Looks good otherwise.

- Felix
