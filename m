Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59907 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab1CRDLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 23:11:37 -0400
Received: by iwn34 with SMTP id 34so3517763iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 20:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300417820-19029-1-git-send-email-lrodriguez@atheros.com>
References: <1300417820-19029-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 17 Mar 2011 20:11:17 -0700
Message-ID: <AANLkTi=58JJNoYG7232ykiOnAK2TX18ROxrfYQir3Wwe@mail.gmail.com>
Subject: Re: [RTF] iwmc3200wifi: fix device registration ordering for cfg80211
To: gregkh@suse.de, "John W. Linville" <linville@tuxdriver.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	vmehta@atheros.com, naveen.singh@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Naveen Singh <nsingh@atheros.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2011 at 8:10 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Without this you can get a race against udev and userspace daemons
> which will try to poke the device even before netdev ops and friends
> are available. Device initialization will fail without this.
>
> Cc: stable@kernel.org
> Cc: Naveen Singh <nsingh@atheros.com>
> Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Cc: Intel Linux Wireless <ilw@linux.intel.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---

Oops sorry, this was supposed to go to Linville.

  LUis
